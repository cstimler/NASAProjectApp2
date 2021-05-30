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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        let thisPhoto = arrayOfPhotos[0]
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
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        // let's find the unique photo for this date:
        let predicate = NSPredicate(format: "dateLabel == %@", selectedDateLabel!)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            arrayOfPhotos = try dataController.viewContext.fetch(fetchRequest)
            print("Selected date label:")
            print(selectedDateLabel)
            print("In SetupFetchedCtnlr")
            print(arrayOfPhotos)
        } catch {
            print(error)
        }
    }
    
    func createDateForLabel(dateString: String) -> String {
        var dateNice: String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateFormatterDisplay = DateFormatter()
        dateFormatterDisplay.dateFormat = "MMM d,yyyy"

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
    

}
