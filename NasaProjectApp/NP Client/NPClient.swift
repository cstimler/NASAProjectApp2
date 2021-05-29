//
//  NPClient.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

// https://api.nasa.gov/planetary/apod/?api_key=MYKEY&start_date=2005-06-16&end_date=2005-07-23
import Foundation


class NPClient {
    
    static var photoInfo = [NASAPhoto]()
    
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
    
    
    class func requestPhotosList(startDate: String, endDate: String, completion: @escaping (Bool, Error?, [NASAPhoto]) -> Void) {
        print("Request photo list entered")
        let request = URLRequest(url: Endpoints.getApod(startDate, endDate).url)
        print(request)
        let configuration = URLSessionConfiguration.default
       // configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) {
            data, response, error in
            if error != nil {
                print("Error wasn't nil")
                print(error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    print("NO DATA")
                    print(error)
                    completion(false, error, photoInfo)
                }
                    return
            }
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode([NASAPhoto].self, from: data)
                self.photoInfo = responseObject
                print("Had success")
                DispatchQueue.main.async {
                completion(true, nil, photoInfo)
                }
            }
                catch  {
                    DispatchQueue.main.async {
                    completion(false, error, photoInfo)
                        print(error)
                        print("Had error")
                    }
                }
}
        task.resume()
    }
    
    class func downloadPhotos(urlString: String, completion: @escaping (Bool, Error?, Data?) -> Void) {
        guard let url = URL(string: urlString) else { return print("UnableToConvertURLToString") }
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print(error)
                DispatchQueue.main.async {
                    completion(false, error, nil)
                }
                return
            }
                if error != nil {
                    print(error)
                } else {
                    print("is downloadind a new photo!")
                    DispatchQueue.main.async {
                    completion(true, nil, data)
                }
            }
        }
        task.resume()
        print("Leaving Task")
    }
    
}
            

    
           




