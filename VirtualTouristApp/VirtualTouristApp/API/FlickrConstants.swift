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

        static let SECRET = "bcc20a93649f2676"
        
        //MARK: URL
        //Using REST request format from Flickr
        static let ApiScheme: String = "https"
        static let ApiHost: String = "www.flickr.com"
        static let ApiPath: String = "/services/rest/"
        static let BaseURL: String = "https://www.flickr.com/services/rest/"
        
    }
 
    //MARK: Parameter Keys
    struct FlickrParameterKeys {
        static let SearchMethod = "method"
        static let APIKey: String = "api_key"
        static let UserID: String = "user_id"
        static let BBOX: String = "bbox"
        static let Media: String = "media"
        static let Latitude: String = "lat"
        static let Longitude: String = "lon"
        static let Gallery: String = "in_gallery"
        static let Extras: String = "extras"
        static let PhotosPerPage: String = "per_page"
        static let SafeSearch = "safe_search"
        static let ResponseFormat = "format"
        static let DisableJSONCallback = "nojsoncallback"
    }
    
    //MARK: Parameter Values
    
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKEY = "03f47bd6c1bce21fa416d9cd84183743"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let MediumURL = "url_n"
        static let SafeSearch = "1"
        static let PhotosPerPage = "21"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
}
