//
//  FlickrClient.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/4/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient {
    
    static let shared = FlickrClient()
    
    // Shared session
    var session = URLSession.shared
    
    // To authenticate
    var SessionID: String? = nil
    
    
    //MARK: Getting Photos for Pinned locations
    func taskForGetPhotosForPin (latitude: Double, longitude: Double, totalPages: Int?, completionHandlerForGetPhotosForPin: @escaping (_ result: PhotosParser?, _ error: NSError?) -> Void) {
        
        //this chooses a random page
        var page: Int {
            if let totalPages = totalPages {
                let page = min(totalPages, 4000)
                return Int(arc4random_uniform(UInt32(page)) + 1)
            }
            return 1
        }
        
        //Parameters
        let parameters = [
            
            FlickrConstants.FlickrParameterKeys.SearchMethod : FlickrConstants.FlickrParameterValues.SearchMethod,
            FlickrConstants.FlickrParameterKeys.APIKey :FlickrConstants.FlickrParameterValues.APIKEY ,
            
            FlickrConstants.FlickrParameterKeys.ResponseFormat :FlickrConstants.FlickrParameterValues.ResponseFormat,
            
            FlickrConstants.FlickrParameterKeys.DisableJSONCallback :FlickrConstants.FlickrParameterValues.DisableJSONCallback,
            
            FlickrConstants.FlickrParameterKeys.Extras :FlickrConstants.FlickrParameterValues.MediumURL,
            
            FlickrConstants.FlickrParameterKeys.PhotosPerPage :FlickrConstants.FlickrParameterValues.PhotosPerPage
            
            ] as [String : AnyObject]
        
        
        //URL Request
        //var request = URLRequest(url: URL(string: "https://www.flickr.com/services/rest/")!)
        let session = URLSession.shared
        let urlString = FlickrConstants.Constants.BaseURL + escapedParameters(parameters as [String:AnyObject])
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        //Create network request
        let task = session.dataTask(with: request) { data, response, error in
            
            func displayError(_ error: String) {
                print(error)
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult[FlickrConstants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[FlickrConstants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Cannot find keys '\(FlickrConstants.FlickrResponseKeys.Photos)' and '\(FlickrConstants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            // select a random photo
            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
            
            /* GUARD: Does our photo have a key for 'url_m'? */
            guard (photoDictionary[FlickrConstants.FlickrResponseKeys.MediumURL] as? String) != nil else {
                displayError("Cannot find key '\(FlickrConstants.FlickrResponseKeys.MediumURL)' in \(photoDictionary)")
                return
            }
            
        }
        
        task.resume()
    }
    
     }

// MARK: Helper for Escaping Parameters in URL

private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
    
    if parameters.isEmpty {
        return ""
    } else {
        var keyValuePairs = [String]()
        
        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // escape it
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            // append it
            keyValuePairs.append(key + "=" + "\(escapedValue!)")
            
        }
        
        return "?\(keyValuePairs.joined(separator: "&"))"
    }
}

    // MARK: Shared Instance
    func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
    
    

