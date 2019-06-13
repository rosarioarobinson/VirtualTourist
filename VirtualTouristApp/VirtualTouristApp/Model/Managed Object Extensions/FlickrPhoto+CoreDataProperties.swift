//
//  FlickrPhoto+CoreDataProperties.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/13/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//
//

import Foundation
import CoreData


extension FlickrPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlickrPhoto> {
        return NSFetchRequest<FlickrPhoto>(entityName: "FlickrPhoto")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var image: String?
    @NSManaged public var url: String?
    @NSManaged public var pins: Pin?

}
