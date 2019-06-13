//
//  CoreDataStack.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/13/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    
    //Information on how to implement CoreData Stack into AppDelegate provided by:
    //https://medium.com/@maddy.lucky4u/swift-4-core-data-part-2-creating-a-simple-app-c4eded1fa55f
    
    //Mark: CoreData Stack
    
    static let sharedStack = CoreDataStack()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "VirtualTourist")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /*func saveViewContext() {
     try? dataController.viewContext.save()
     }*/
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
}
