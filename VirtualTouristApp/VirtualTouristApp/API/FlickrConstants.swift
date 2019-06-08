//
//  FlickrConstants.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/7/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation


class FlickrConstants {
    
    //MARK: Constants
    struct Constants {
        
        //MARK: API Key
        static let APIKEY = "03f47bd6c1bce21fa416d9cd84183743"
        static let SECRET = "bcc20a93649f2676"
        
        //MARK: URL
        //Using REST request format from Flickr
        static let ApiScheme: String = "https"
        static let ApiHost: String = "www.flickr.com"
        static let ApiPath: String = "/services/rest/"
        static let BaseURL: String = "https://www.flickr.com/services/rest/"
        
    }
 
    //MARK: Methods
    struct Methods {
        
        static let flickrSearch = "flickr.photos.search"
    }
    
    struct FlickrParameterKeys {
        static let APIKey: String = "api_key"
        static let UserID: String = "user_id"
        static let BBOX: String = "bbox"
        static let Media: String = "media"
        static let Latitude: String = "lat"
        static let Longitude: String = "lon"
        static let Gallery: String = "in_gallery"
        static let Extras: String = "extras"
        static let PerPage: String = "per_page"
        static let Page: String = "page"
    }
    
    
    
}
