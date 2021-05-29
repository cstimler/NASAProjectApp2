//
//  FavoritePhotosViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/29/21.
//

import UIKit

class FavoritePhotosViewController: UIViewController, UIImagePickerControllerDelegate {
    
    var photoCoreData: Photo!
    
    
    @IBOutlet weak var infoText: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        infoText.isHidden = !infoText.isHidden
    }
    
    
    @IBAction func showSharingOptions(_ sender: Any) {
        var image: UIImage?
        let data = photoCoreData.pic
        if let data = data {
        image = UIImage(data: data)
        }
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pic = photoCoreData.pic
        if let pic = pic {
        imageView.image = UIImage(data: pic)
        }
        infoText.isHidden = true
        let date = photoCoreData.dateLabel
        let newDate = createDateForLabel(dateString: date!)
        let newTitle = photoCoreData.title
        let newBlurb = photoCoreData.blurb
        if let newTitle = newTitle {
            if let newBlurb = newBlurb {
        infoText.text = newDate + ":" + newTitle + "\n\n" + newBlurb
        }
        }
        // Do any additional setup after loading the view.
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
