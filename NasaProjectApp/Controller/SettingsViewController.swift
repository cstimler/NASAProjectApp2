//
//  SettingsViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    var dateToStart: String = "2000-01-01"
    var dateToEnd: String = "2000-01-08"
    
    var dataController:DataController!
    var myCalendar = Calendar(identifier: .gregorian)
    
    var dateForCalendar: Date?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func readyButtonPressed(_ sender: Any) {
        
     //   let usLocale = Locale(identifier: "en_US")
        
        print(dateToStart)
        print(dateToEnd)
    }
    
    @IBAction func favoriteHeartButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "fromSettingsToFavorites", sender: self)
    }
    
    //  I used code from the following website to allow/disallow this view controller rotations:
    // Some landscape views were cutting off the "I'm Ready" button https://stackoverflow.com/questions/36358032/override-app-orientation-setting/48120684#48120684
    
    func setAutoRotation(value: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
       appDelegate.autoRotation = value
    }
    }
    
    // https://stackoverflow.com/questions/35700281/date-format-in-swift
    func dateFormatter(date: Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    // https://stackoverflow.com/questions/3785610/uidatepicker-upon-date-changed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://www.swiftpal.io/articles/new-uidatepicker-in-ios-14:
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        // The first date for photos is June 16, 1995:
        datePicker.minimumDate = Date(timeIntervalSinceReferenceDate: -175000000)
        datePicker.maximumDate =  myCalendar.date(byAdding: .day, value: -8, to: Date())
        // https://stackoverflow.com/questions/3785610/uidatepicker-upon-date-changed
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
        getStartDateFromPlist()
    }
    // remember the last date that we were searching at from previous session, retrieve it, and set the datePicker:
    func getStartDateFromPlist() {
        if let thisStartingDate = UserDefaults.standard.value(forKey: "startDate") {
            datePicker.date = thisStartingDate as! Date
            // recalled date from prior session needs to be translated to "dateToStart" and "dateToEnd"
            datePickerChanged(datePicker: datePicker)
        } else {
            // January 1, 2000:
            datePicker.date = Date(timeIntervalSinceReferenceDate: 86400)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAutoRotation(value: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setAutoRotation(value: true)
        // let's store the starting date in plist file!
        if let dateForCalendar = dateForCalendar {
        let a = dateForCalendar as Date
        UserDefaults.standard.setValue(a, forKey: "startDate")
    }
    }
    
    // https://stackoverflow.com/questions/3785610/uidatepicker-upon-date-changed
    @objc func datePickerChanged(datePicker: UIDatePicker) {
        print(datePicker.date)
        dateForCalendar = datePicker.date
        dateToStart = dateFormatter(date: datePicker.date, dateFormat: "yyyy-MM-dd")
        let dateFinal = myCalendar.date(byAdding: .day, value: 7, to: datePicker.date)
        if let dateFinal = dateFinal {
        dateToEnd = dateFormatter(date: dateFinal, dateFormat: "yyyy-MM-dd")
    }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSettingsToDownload"
        {
        let controller = segue.destination as! DownloadPhotosTableViewController
        
            print("Passing start:" + self.dateToStart)
            print("Passing end:" + self.dateToEnd)
            controller.dateToStart = self.dateToStart
            controller.dateToEnd = self.dateToEnd
            controller.dataController = self.dataController
        }
        
        if segue.identifier == "fromSettingsToFavorites"
        {
            let controller = segue.destination as! UINavigationController
            let favoritesCollectionViewController = controller.topViewController as! FavoritesCollectionViewController
            favoritesCollectionViewController.dataController = dataController
        }

    }
    
    // we want to eventually return to this view controller, perhaps if we want to search on a different date, so lets set up an "unwind segue here":  https://medium.com/flawless-app-stories/unwind-segues-in-swift-5-e392134c65fd
    
    @IBAction func unwind(_ seg: UIStoryboardSegue) {
        
    }
    
}

