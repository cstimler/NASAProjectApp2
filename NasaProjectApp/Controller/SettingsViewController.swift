//
//  SettingsViewController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    var dateToStart: String = "2000-01-01"
    var dateToEnd: String = "2000-01-07"
    
    var dataController:DataController!
    var myCalendar = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func readyButtonPressed(_ sender: Any) {
        
     //   let usLocale = Locale(identifier: "en_US")
        
        print(dateToStart)
        print(dateToEnd)
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
        datePicker.maximumDate = Date()
        // https://stackoverflow.com/questions/3785610/uidatepicker-upon-date-changed
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
    }
    
    // https://stackoverflow.com/questions/3785610/uidatepicker-upon-date-changed
    @objc func datePickerChanged(datePicker: UIDatePicker) {
        print(datePicker.date)
        dateToStart = dateFormatter(date: datePicker.date, dateFormat: "yyyy-MM-dd")
        let dateFinal = myCalendar.date(byAdding: .day, value: 7, to: datePicker.date)
        if let dateFinal = dateFinal {
        dateToEnd = dateFormatter(date: dateFinal, dateFormat: "yyyy-MM-dd")
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DownloadPhotosTableViewController
        
            print("Passing start:" + self.dateToStart)
            print("Passing end:" + self.dateToEnd)
            controller.dateToStart = self.dateToStart
            controller.dateToEnd = self.dateToEnd
            controller.dataController = self.dataController

    }
    
}

