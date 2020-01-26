//
//  FlickrPhotos.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/11/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation

//Code to Parse data from Flickr

struct PhotosParser: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let pages: Int
    let photo: [PhotoParser]
}

struct PhotoParser: Codable {
    
    let url: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_m"
        case title
    }
}

