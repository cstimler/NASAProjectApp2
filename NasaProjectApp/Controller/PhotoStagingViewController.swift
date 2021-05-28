//
//  PhotoStagingViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit
import SafariServices

class PhotoStagingViewController: UIViewController {
    
    var dataController:DataController!
    
    var photoArray: [String]!
    
    var photoImage: UIImage?

    @IBOutlet weak var photoStage: UIImageView!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        // we will register the current Photo with Core Data:
        let photo = Photo(context: dataController.viewContext)
        photo.dateLabel = photoArray[0]
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photoArray)
        if photoArray[3].prefix(23) == "https://www.youtube.com" || photoArray[3].prefix(24) == "https://player.vimeo.com" {
            openWebpageWithSafari(urlString: photoArray[3])
        } else {
            NPClient.downloadPhotos(urlString: self.photoArray[3]) { (success, error, data) in
            if success {
                if let data = data {
                    self.photoImage = UIImage(data: data)
                    self.photoStage.image = self.photoImage
                    
                }
            }
            else {
                print("Photo transfer failed.")
            }
        }
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
