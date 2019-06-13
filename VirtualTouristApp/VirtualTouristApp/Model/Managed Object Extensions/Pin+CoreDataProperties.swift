//
//  Pin+CoreDataProperties.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/13/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var string: String?
    @NSManaged public var flickrPhotos: NSSet?

}

// MARK: Generated accessors for flickrPhotos
extension Pin {

    @objc(addFlickrPhotosObject:)
    @NSManaged public func addToFlickrPhotos(_ value: FlickrPhoto)

    @objc(removeFlickrPhotosObject:)
    @NSManaged public func removeFromFlickrPhotos(_ value: FlickrPhoto)

    @objc(addFlickrPhotos:)
    @NSManaged public func addToFlickrPhotos(_ values: NSSet)

    @objc(removeFlickrPhotos:)
    @NSManaged public func removeFromFlickrPhotos(_ values: NSSet)

}
