//
//  AppDelegate.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/4/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //let dataController = DataController(modelName: "VirtualTourist")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DataController.sharedInstance.load()
        
        /*if let viewController = viewController {
         viewController.managedObjectContext = self.managedObjectContext
         }*/
        let travelLocationsMapViewController = window?.rootViewController as! TravelLocationsMapViewController
        //travelLocationsMapViewController.dataController = dataController
        
        return true
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //dataController.saveContext()
    }
    
}

