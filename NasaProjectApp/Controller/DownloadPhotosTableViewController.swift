//
//  DownloadPhotosTableViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit
import SafariServices

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

    var photoInfoArray = [[String]]()
   // var tempPhoto = [Int:UIImage]()
    var myCalendar = Calendar(identifier: .gregorian)
    // setup cache as in: https://www.hackingwithswift.com/example-code/system/how-to-cache-data-using-nscache
    var cache = NSCache<NSString, UIImage>()
    
    var passedInteger: Int = 0
    // keep count of photos loaded to manage enabling of download button:
    var countPhotos: Int = 0
    
    @IBOutlet weak var loadMoreImagesButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    @IBAction func loadMoreImagesPressed(_ sender: Any) {
        loadMoreImagesButton.isEnabled = false
        // activity indicator should start up again once a reload is in progress:
        activityIndicatorIsVisible(true)
        generateNewStartEndDates()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: dateToStart)
        guard startDate! <  myCalendar.date(byAdding: .day, value: -8, to: Date())! else {
            showPhotoFailure(message: "You are near the current date and therefore have reached the end of available dates!  Choose an earlier start date to resume your photo explorations!")
            activityIndicatorIsVisible(false)
            return
        }
        NPClient.requestPhotosList(startDate: dateToStart, endDate: dateToEnd) { (success, error, nasaPhotos) in
            if success {
                self.photoInfo = nasaPhotos
                self.parsePhotoInfo()
                // about to reload populated tableview:
                self.activityIndicatorIsVisible(false)
                self.tableView.reloadData()
        } else {
            // (NEW CHANGE) alert is shown if unable to retrieve photo list upon reload attempt:
            self.showPhotoFailure(message: "Your internet connection is off-line OR the hosting www.nasa.gov website is down.  Please try again later!")
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
            }

    override func viewDidLoad() {
        super.viewDidLoad()
        // start activity indicator upon loading view:
        activityIndicatorIsVisible(true)
        // disable load button upon loading:
        loadMoreImagesButton.isEnabled = false
        NPClient.requestPhotosList(startDate: dateToStart, endDate: dateToEnd) { (success, error, nasaPhotos) in
            if success {
                self.photoInfo = nasaPhotos
                self.parsePhotoInfo()
                // about to reload, make activity indicator disappear:
                self.activityIndicatorIsVisible(false)
                self.tableView.reloadData()
            } else  {
                // in case of failure to download photos list:
                self.showPhotoFailure(message: "Your internet connection is off-line OR the hosting www.nasa.gov website is down.  Please try again later!")
            }
            
        }
            }
        
    // https://cocoacasts.com/swift-fundamentals-how-to-convert-a-string-to-a-date-in-swift
    // this is activated when user wishes to reload photos:
    func generateNewStartEndDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: dateToStart)
        let start = myCalendar.date(byAdding: .day, value: 8, to: startDate!)
        let end = myCalendar.date(byAdding: .day, value: 15, to: startDate!)
        dateToStart = dateFormat(date: start!, dateFormat: "yyyy-MM-dd")
        dateToEnd = dateFormat(date: end!, dateFormat: "yyyy-MM-dd")
    }
    
    // https://stackoverflow.com/questions/35700281/date-format-in-swift
    func dateFormat(date: Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    // format dates nicely for presentation in the tableview:
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
    
    // helps to determine when the "Load More Images" button should be re-enabled:
    func keepCountOfPhotoDownloads() {
        countPhotos = countPhotos + 1
        if countPhotos == 8 {
            loadMoreImagesButton.isEnabled = true
            countPhotos = 0
        }
    }
    
    // manages the activity indicator properly:
    func activityIndicatorIsVisible(_ isVisible: Bool) {
        if isVisible {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    

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
            if photoInfoArray[indexPath.item][3].prefix(23) == "https://www.youtube.com" || photoInfoArray[indexPath.item][3].prefix(24) == "https://player.vimeo.com" {
                // after 8 downloads we re-enable download button
                self.keepCountOfPhotoDownloads()
                cell.photoImageView.image = UIImage(named: "youtubeIcon")
                cell.photoTextView.text = createDateForLabel(dateString: photoInfoArray[indexPath.item][0]) + ":   " + photoInfoArray[indexPath.item][2]
            } else {
                cell.photoTextView.text = createDateForLabel(dateString: photoInfoArray[indexPath.item][0]) + ":   " + photoInfoArray[indexPath.item][2]
                    if let cachedVersion = self.cache.object(forKey: self.photoInfoArray[indexPath.item][0] as NSString) {
                        cell.photoImageView.image = cachedVersion
                    } else {
                        NPClient.downloadPhotos(urlString: self.photoInfoArray[indexPath.item][3]) { (success, error, data) in
                            if success {
                                // after 8 downloads we re-enable download button
                                self.keepCountOfPhotoDownloads()
                        if let data = data {
                        let resizedImage = UIImage(data:data)?.imageResized()
                            if let resizedImage = resizedImage {
                            self.cache.setObject(resizedImage, forKey: self.photoInfoArray[indexPath.item][0] as NSString)
                                cell.photoImageView.image = resizedImage
                            }
                    }
                    }
                 else {
                    print(error)
                    // (NEW CHANGE): alert is now shown if there is a problem downloading a photo to the tableview:
                    if self.loadMoreImagesButton.isEnabled == false {
                        self.showPhotoFailure(message: "One or more photos cannot be downloaded.  This can be due to a missing photo or a bad connection.  Try another date and/or try again later.")
                        // re-enable the button because in the case of a single bad photo the user might want to see the others that were downloaded successfully:
                        self.loadMoreImagesButton.isEnabled = true
                    }
                }
            }
        }
       
    }

    
}
        return cell
    }
    
    
    // determine correct segue destination and pass necessary data:
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerSegway(indexPath.item) { (success) in
            if success {
                if !(self.photoInfoArray[self.passedInteger][3].prefix(23) == "https://www.youtube.com" || self.photoInfoArray[self.passedInteger][3].prefix(24) == "https://player.vimeo.com")
                {
                self.performSegue(withIdentifier: "fromTableToStage", sender: self)
                }  else {
                    self.openWebpageWithSafari(urlString:self.photoInfoArray[self.passedInteger][3])
                }
        }
    }
    }
    // we sometimes need to open Vimeo or YouTube videos:
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
    
    // need to make sure that the selected table row is stored in "passedInteger" BEFORE "performSegue" is called:
    func triggerSegway(_ int: Int, completion: @escaping (Bool) -> Void) {
        self.passedInteger = int
        completion(true)
    }
    
// this view controller will segue to either the PhotoStagingViewController or a Safari browser:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !(self.photoInfoArray[passedInteger][3].prefix(23) == "https://www.youtube.com" || self.photoInfoArray[passedInteger][3].prefix(24) == "https://player.vimeo.com")
        {
        let controller = segue.destination as! PhotoStagingViewController
        controller.dataController = dataController
        controller.photoArray = self.photoInfoArray[passedInteger]
    }
    }
    
    // alert for download failures:
    func showPhotoFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "DOWNLOAD ALERT!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }
    }
        }

    
// Ease the burden of caching by providing smaller thumbprints for the tableview images:
// https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
extension UIImage {
    func imageResized() -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: 96, height: 80)).image { _ in
            draw(in: CGRect(origin: .zero, size: CGSize(width: 96, height: 80)))
        }
    }
}
