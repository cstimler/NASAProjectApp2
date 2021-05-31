//
//  FavoritePhotosViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/29/21.
//

import UIKit
import CoreData

class FavoritePhotosViewController: UIViewController, UIImagePickerControllerDelegate, NSFetchedResultsControllerDelegate {
    
    // var photoCoreData: Photo!
    
    var arrayOfPhotos: [Photo]!
    
    var dataController: DataController!
    
    var selectedDateLabel: String?
    
    var thisPhoto: Photo!
    
    
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoText.isHidden = !infoText.isHidden
    }
    
    
    @IBAction func showSharingOptions(_ sender: Any) {
        var image: UIImage?
        let data = arrayOfPhotos[0].pic
        if let data = data {
        image = UIImage(data: data)
        }
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        areYouSureYouWantToDelete() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(wasTapped(_:)))
        imageView.addGestureRecognizer(tap)
        setupFetchedResultsController()
        thisPhoto = arrayOfPhotos[0]
        let pic = thisPhoto.pic
        if let pic = pic {
        imageView.image = UIImage(data: pic)
        }
        infoText.isHidden = true
        let date = thisPhoto.dateLabel
        let newDate = createDateForLabel(dateString: date!)
        let newTitle = thisPhoto.title
        let newBlurb = thisPhoto.blurb
        if let newTitle = newTitle {
            if let newBlurb = newBlurb {
                // blurb in this context should have more info, including date and title since this can't be easily retrieved at this point:
        infoText.text = newDate + ": " + newTitle + "\n\n" + newBlurb
        }
        }
        // Do any additional setup after loading the view.
    }
    
    // amazing code that I can use to pass the dataController back to the previous viewcontroller when accessed using back button!: https://stackoverflow.com/questions/27713747/execute-action-when-back-bar-button-of-uinavigationcontroller-is-pressed
    override func viewWillDisappear(_ animated: Bool) {
        try? dataController.viewContext.save()
        if isMovingFromParent {
            print("Within first parenthesis")
                    if let viewControllers = self.navigationController?.viewControllers {
                        if (viewControllers.count >= 1) {
                            print("Within second parenthesis")
                            let previousViewController = viewControllers[viewControllers.count-1] as! FavoritesCollectionViewController
                            previousViewController.dataController = dataController
                        }
                    }
                }
    }
    
    
       
    @objc func wasTapped(_ sender:UIGestureRecognizer) {
        if infoText.isHidden == false {
            infoText.isHidden = true
        }
    }
        
    
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        // let's find the unique photo for this date:
        let predicate = NSPredicate(format: "dateLabel == %@", selectedDateLabel!)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            arrayOfPhotos = try dataController.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    
    func createDateForLabel(dateString: String) -> String {
        var dateNice: String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMM d, yyyy"
        if let date: Date = (dateFormatter.date(from: dateString)) {
            dateNice = dateFormatterDisplay.string(from: (date as NSDate) as Date)
        }
        if let dateNice = dateNice {
            return dateNice
        }
        else {
            return ""
        }
    }
    // https://stackoverflow.com/questions/25511945/swift-alert-view-with-ok-and-cancel-which-button-tapped:
    
    func areYouSureYouWantToDelete() {
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this photo?", preferredStyle: UIAlertController.Style.alert)
    deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        self.dataController.viewContext.delete(self.thisPhoto)
    }))
    deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          return
    }))
    present(deleteAlert, animated: true, completion: nil)
    }

}
