//
//  NASAPhotosSearchResponse.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import Foundation

struct NASAPhoto: Codable {
    var date: String
    var explanation: String
    var title: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case title
        case url
        }
    }


