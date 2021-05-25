//
//  Photo + Extension.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/25/21.
//

import Foundation
import CoreData

extension Photo {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
