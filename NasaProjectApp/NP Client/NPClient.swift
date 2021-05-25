//
//  NPClient.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

// https://api.nasa.gov/planetary/apod/?api_key=MYKEY&start_date=2005-06-16&end_date=2005-07-23
import Foundation


class NPClient {
    
    static var photoInfo: [NASAPhoto]!
    
    struct Auth {
        
        static var apiKey = "MYKEY"
    }
    
    enum Endpoints {
        
        static let urlBase = "https://api.nasa.gov/planetary/apod"
        
        case getApod(String, String)
        
        var stringValue: String {
            switch self {
            
            case .getApod(let startDate, let endDate): return Endpoints.urlBase + "?api_key=" + Auth.apiKey + "&start_date=\(startDate)" + "&end_date=\(endDate)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func requestPhotosList(startDate: String, endDate: String, completion: @escaping (Bool, Error?) -> Void) {
        
        var request = URLRequest(url: Endpoints.getApod(startDate, endDate).url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                    return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode([NASAPhoto].self, from: data)
                self.photoInfo = responseObject
                DispatchQueue.main.async {
                completion(true, nil)
                }
            }
                catch  {
                    DispatchQueue.main.async {
                    completion(false, error)
                    }
                }
}
        task.resume()
    }
    
    class func downloadPhotoInfo(completion: @escaping (Bool, Error?, [String]?) -> Void)  {
        for photo in photoInfo {
            let photoFields: [String] = [photo.date, photo.explanation, photo.title, photo.url]
            completion(true, nil, photoFields)
                
                }
            }
            
        }
    
           




