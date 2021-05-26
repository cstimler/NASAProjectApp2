//
//  DownloadPhotosTableViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit
import QuickLookThumbnailing

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var photoTextView: UITextView!
    
}

class DownloadPhotosTableViewController: UITableViewController {
    
    var dateToStart: String!
    var dateToEnd: String!
    var reuseIdentifier: String = "PhotoCell"
    
    var dataController:DataController!
    
    var photoInfo: [NASAPhoto] = []
    var thumbnailArray = [QLThumbnailRepresentation]()
    var photoInfoArray = [[String]]()
    var tempPhoto = [Int:UIImage]()
    
    // https://developer.apple.com/documentation/quicklookthumbnailing/creating_quick_look_thumbnails_to_preview_files_in_your_app
    func generateThumbnailRepresentations(url: URL) -> UIImage {
        var thisThumbnail = QLThumbnailRepresentation()
        // Set up the parameters of the request.
        
        let size: CGSize = CGSize(width: 60, height: 90)
        let scale = UIScreen.main.scale
        
        // Create the thumbnail request.
        let request = QLThumbnailGenerator.Request(fileAt: url,
                                                   size: size,
                                                   scale: scale,
                                                   representationTypes: .thumbnail)
        
        // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { (thumbnail, type, error) in
        //    DispatchQueue.main.async {
                if thumbnail == nil || error != nil {
                    print("Unable to create thumbnail")
                    print(error)
                } else {
                    if let thumbnail = thumbnail {
                    thisThumbnail = thumbnail
                   /* if let thumbnail = thumbnail {
                        self.thumbnailArray.append(thumbnail) */
                    
                    }
                }
          //  }
        
        }
        return thisThumbnail.uiImage
    }
    
    func parsePhotoInfo()  {
        var photoInfoArrayTemp = [[String]]()
        for photo in photoInfo {
            let photoFields: [String] = [photo.date, photo.explanation, photo.title, photo.url]
            photoInfoArrayTemp.append(photoFields)
                }
            photoInfoArray = photoInfoArrayTemp
        print("Finished parsing photos")
        print(photoInfoArray.count)
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Date to start is:" + dateToStart)
        print("Date to eend is:" + dateToEnd)
        NPClient.requestPhotosList(startDate: dateToStart, endDate: dateToEnd) { (success, error, nasaPhotos) in
            if success {
                print("Had success in vc!")
                self.photoInfo = nasaPhotos
                self.parsePhotoInfo()
                self.tableView.reloadData()
                    }
                }
            }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photoInfoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoTableViewCell
        // setup placeholder image:
        cell.photoImageView.image = UIImage(named: "VirtualTourist_76")
        // assign the title to the text:
        if photoInfoArray != [] {
        cell.photoTextView.text = photoInfoArray[indexPath.item][2]
            NPClient.downloadPhotos(urlString: self.photoInfoArray[indexPath.item][3]) { (success, error, data) in
                if success {
                    print("has success in tableview too!!!!!")
                    if self.tempPhoto[indexPath.item] == nil {
                        if let data = data {
                            let resizedImage = UIImage(data:data)?.imageResized()
                        cell.photoImageView.image = resizedImage
                        self.tempPhoto[indexPath.item] = resizedImage
                    }
                    }
                    else {
                        print("GOT INTO ELSEEEEE@!")
                        cell.photoImageView.image = self.tempPhoto[indexPath.item]
                    }
                } else {
                    print(error)
                }
            }
        }
        // replace placeholder image only if and when a thumbnail is available:
        /*
        let place = indexPath.item
        if place < thumbnailArray.count
        {
            cell.imageView?.image = thumbnailArray[place].uiImage
        }
         
          let thisUrl = URL(string: photoInfoArray[indexPath.item][3])
            if let thisUrl = thisUrl {
            cell.imageView?.image = generateThumbnailRepresentations(url: thisUrl)
        } // close check on photoInfoArray */
        
        return cell
    }
}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
// https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
extension UIImage {
    func imageResized() -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 96, height: 80)).image { _ in
            draw(in: CGRect(origin: .zero, size: CGSize(width: 96, height: 80)))
        }
    }
}
