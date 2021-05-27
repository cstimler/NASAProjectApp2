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
    var myCalendar = Calendar(identifier: .gregorian)
    // setup cache as in: https://www.hackingwithswift.com/example-code/system/how-to-cache-data-using-nscache
    var cache = NSCache<NSString, UIImage>()
    var passedInteger: Int = 0
    
    
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
    
    
    
    @IBAction func loadMoreImagesPressed(_ sender: Any) {
        generateNewStartEndDates()
        NPClient.requestPhotosList(startDate: dateToStart, endDate: dateToEnd) { (success, error, nasaPhotos) in
            if success {
                print("Had success in reload!")
                self.photoInfo = nasaPhotos
                self.parsePhotoInfo()
                self.tableView.reloadData()
                    }
                }
    }
    
    func parsePhotoInfo()  {
        var photoInfoArrayTemp = [[String]]()
        for photo in photoInfo {
            let photoFields: [String] = [photo.date, photo.explanation, photo.title, photo.url]
            photoInfoArrayTemp.append(photoFields)
                }
        photoInfoArray = photoInfoArray + photoInfoArrayTemp
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
        
    // https://cocoacasts.com/swift-fundamentals-how-to-convert-a-string-to-a-date-in-swift
    
    func generateNewStartEndDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: dateToStart)
        let start = myCalendar.date(byAdding: .day, value: 9, to: startDate!)
        let end = myCalendar.date(byAdding: .day, value: 17, to: startDate!)
        dateToStart = dateFormat(date: start!, dateFormat: "yyyy-MM-dd")
        dateToEnd = dateFormat(date: end!, dateFormat: "yyyy-MM-dd")
    }
    
    // https://stackoverflow.com/questions/35700281/date-format-in-swift
    func dateFormat(date: Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
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
            if photoInfoArray[indexPath.item][3].prefix(23) == "https://www.youtube.com" {
                cell.photoImageView.image = UIImage(named: "youtubeIcon")
                cell.photoTextView.text = photoInfoArray[indexPath.item][2]
            } else {
        cell.photoTextView.text = photoInfoArray[indexPath.item][2]
                    if let cachedVersion = self.cache.object(forKey: self.photoInfoArray[indexPath.item][0] as NSString) {
                        cell.photoImageView.image = cachedVersion
                        print("was in first area")
                    } else {
                        NPClient.downloadPhotos(urlString: self.photoInfoArray[indexPath.item][3]) { (success, error, data) in
                            if success {
                        if let data = data {
                        let resizedImage = UIImage(data:data)?.imageResized()
                            if let resizedImage = resizedImage {
                            self.cache.setObject(resizedImage, forKey: self.photoInfoArray[indexPath.item][0] as NSString)
                                cell.photoImageView.image = resizedImage
                                print("was in second area")
                            }
                    }
                    }
                 else {
                    print(error)
                }
            }
        }
       
    }

    
}
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        triggerSegway(indexPath.item) { (success) in
            if success {
                self.performSegue(withIdentifier: "fromTableToStage", sender: self)
    }
        }
    }
    
    // need to make sure that the selected table row is stored in "passedInteger" BEFORE "performSegue" is called:
    func triggerSegway(_ int: Int, completion: @escaping (Bool) -> Void) {
        self.passedInteger = int
        completion(true)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! PhotoStagingViewController
        
        controller.dataController = dataController
        controller.photoArray = self.photoInfoArray[passedInteger]
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
     
    */
// https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
extension UIImage {
    func imageResized() -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 96, height: 80)).image { _ in
            draw(in: CGRect(origin: .zero, size: CGSize(width: 96, height: 80)))
        }
    }
}
