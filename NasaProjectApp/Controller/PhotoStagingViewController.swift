//
//  PhotoStagingViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit
import SafariServices
import CoreData

class PhotoStagingViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var dataController:DataController!
    
    var photoArray: [String]!
    
    var photoImage: UIImage?
    
    var photoData: Data!

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var photoStage: UIImageView!
    
    @IBOutlet weak var infoTextView: UITextView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    
    @IBAction func makeTitleVisible(_ sender: Any) {
        // actually toggles title visibility
        titleTextView.isHidden = !titleTextView.isHidden
    }
    
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoTextView.isHidden = !infoTextView.isHidden
    }
    
    
    
    @IBAction func favoriteHeartButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "fromStageToFavorites", sender: self)
    }
    
    func activityIndicatorIsVisible(_ isVisible: Bool) {
        if isVisible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UINavigationController
        let favoritesCollectionViewController = controller.topViewController as! FavoritesCollectionViewController
        favoritesCollectionViewController.dataController = dataController
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // we will register the current Photo with Core Data:
        if thisIsARepeatPhoto() {
            showPhotoFailure(message: "You have already saved this photo.  To resave, please delete the old photo and save this new one.")
        }
        let photo = Photo(context: dataController.viewContext)
        photo.dateLabel = photoArray[0]
        photo.blurb = photoArray[1]
        photo.title = photoArray[2]
        photo.urlString = photoArray[3]
        // https://stackoverflow.com/questions/32297704/convert-uiimage-to-nsdata-and-convert-back-to-uiimage-in-swift/50729656
        photo.pic = generatePicImage().pngData()
        do {
        try dataController.viewContext.save()
    } catch
    {
        print("GOT INTO ERROR FOR SAVING CONTEXT")
        print(error)}
    }
    
    func thisIsARepeatPhoto() -> Bool {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        // let's find the unique photo for this date:
        let predicate = NSPredicate(format: "dateLabel == %@", photoArray[0])
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let arrayOfPhotos = try dataController.viewContext.fetch(fetchRequest)
            if arrayOfPhotos == [] {
                return false
            } else {
                return true
            }
        } catch {
            print(error)
            return true   // hmmm
        }
    }
    
    func setupTitleTextView() {
        titleTextView.isHidden = true
        titleTextView.text = photoArray[2]
        titleTextView.delegate = self
        titleTextView.typingAttributes = titleTextAttributes
        let fancyString = NSAttributedString(string: photoArray[2], attributes: titleTextAttributes)
        titleTextView.attributedText = fancyString
        titleTextView.isEditable = true
        titleTextView.textAlignment = .center
    }
    
    let titleTextAttributes : [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30), .strokeWidth: -5]
    
   //Allows "return" to retract keyboard: https://stackoverflow.com/questions/50462356/xcode-9-textviewshouldreturn
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return true
            } else {
                return true
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // start activity indicator as photo is loading:
        activityIndicatorIsVisible(true)
        infoTextView.isHidden = true
        infoTextView.isEditable = false
        infoTextView.text = photoArray[1]
        infoTextView.isScrollEnabled = true
        setupTitleTextView()
        photoStage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped(_:)))
        photoStage.addGestureRecognizer(tap)
        if photoArray[3].prefix(23) == "https://www.youtube.com" || photoArray[3].prefix(24) == "https://player.vimeo.com" {
            openWebpageWithSafari(urlString: photoArray[3])
        } else {
            NPClient.downloadPhotos(urlString: self.photoArray[3]) { (success, error, data) in
            if success {
                if let data = data {
                    // photo about to appear, turn off activity indicator:
                    self.activityIndicatorIsVisible(false)
                    self.photoImage = UIImage(data: data)
                    self.photoStage.image = self.photoImage
                    self.photoData = data
                }
            }
            else {
                print("Photo transfer failed.")
            }
        }
        // Do any additional setup after loading the view.
    }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? dataController.viewContext.save()
    }
    
    // toggle through a variety of possible views so user can select their preference:
    @objc func wasTapped(_ sender:UIGestureRecognizer) {
        if infoTextView.isHidden == false {
            infoTextView.isHidden = true
            return
        }
        if photoStage.contentMode == .scaleToFill {
            photoStage.contentMode = .scaleAspectFit
        } else {
        if photoStage.contentMode == .scaleAspectFit {
            photoStage.contentMode = .scaleAspectFill }
         else {
        if photoStage.contentMode == .scaleAspectFill {
        photoStage.contentMode = .scaleToFill
        }
    }
        }
    }
    
    func openWebpageWithSafari(urlString: String) {
        if let url = URL(string: urlString) {
        DispatchQueue.main.async {
        // https://www.hackingwithswift.com/read/32/3/how-to-use-sfsafariviewcontroller-to-browse-a-web-page
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration:config)
            self.present(vc, animated: true)
            }
        }
    }
    
    func generatePicImage() -> UIImage {
        // generate the image to be saved to Photo in CordData

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let picImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return picImage
    }
    
    func showPhotoFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "REPEAT PHOTOS!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }
    }

}
