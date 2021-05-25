//
//  SettingsViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    var dateToStart: String = ""
    var dateToEnd: String = ""
    
    var dataController:DataController!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func readyButtonPressed(_ sender: Any) {
        
     //   let usLocale = Locale(identifier: "en_US")
        let date = datePicker.date
        dateToStart = dateFormatter(date: date, dateFormat: "yyyy-MM-dd")
        print(dateToStart)
        let myCalendar = Calendar(identifier: .gregorian)
        //https://www.globalnerdy.com/2020/05/28/how-to-work-with-dates-and-times-in-swift-5-part-3-date-arithmetic/
       let dateFinal = myCalendar.date(byAdding: .day, value: 7, to: date)
        dateToEnd = dateFormatter(date: dateFinal!, dateFormat: "yyyy-MM-dd")
        print(dateToEnd)
       
    }
    // https://stackoverflow.com/questions/35700281/date-format-in-swift
    func dateFormatter(date: Date,dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://www.swiftpal.io/articles/new-uidatepicker-in-ios-14:
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        // The first date for photos is June 16, 1995:
        datePicker.minimumDate = Date(timeIntervalSinceReferenceDate: -175000000)
        datePicker.maximumDate = Date()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DownloadPhotosTableViewController
        
        controller.dateToStart = dateToStart
        controller.dateToEnd = dateToEnd
        controller.dataController = dataController
    }
    
}

