//
//  CustomErrors.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/25/21.
//

import Foundation

enum PhotoError: Error {
    case corruptedStringArray
}

extension PhotoError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .corruptedStringArray: return NSLocalizedString("Photo info from string was corrupted or could not be downloaded", comment: "Invalid Array")
        }
    }
}
