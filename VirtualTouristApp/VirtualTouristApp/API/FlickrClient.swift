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
    
    //GETting Photo Data
    func taskForGetMethod(_ method: String, url: URL, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        //Parameters
        let url = URL(string: FlickrConstants.Constants.BaseURL)
        
        //Request
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        //create task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                sendError("No data was returned by the request!")
                return
            }
            
        }
        task.resume()
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
    }
    
    
}
