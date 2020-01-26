//
//  TravelLocationsMapViewController.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/4/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editPin: UIBarButtonItem!
    
   
    var dataController = DataController.sharedInstance
    var viewContext: DataController!
    var appDelegate: AppDelegate!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var editBarButton: UIBarButtonItem!
    var pin = [Pin]()
    var annotations = [MKPointAnnotation]()
    

    //Fetched Results View Controller
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "string", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "Pins")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
         dataController = appDelegate.dataController*/
        
        editPin.isEnabled = true
        //edit button
        navigationItem.rightBarButtonItem = editButtonItem
        editPin = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(getter: self.editPin))
        
        //code for long press gesture pin
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(annotationPins(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       fetchAllPins()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    //MARK: ACTIONS

    
    @IBAction func editPinsPressed(sender: UIBarButtonItem ) {
    
        //edit functionality currently not working?
        if isEditing {
            isEditing = false
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: Selector(("editPin:")))
        } else {
            isEditing = true
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("editPin:")))
        }
    
        self.setEditing(isEditing, animated: true)
        
    }
    
    @objc func annotationPins(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != .began {return}
        
        let pressPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(pressPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        //causing the app to crash!! 
        /*let pin: Pin = Pin(context: DataController.sharedInstance.viewContext)
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude*/
        savePin(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        DataController.sharedInstance.saveContext()

        
    }
    
    //Fetching Pins
    //Tutorial assistance from: https://medium.com/@maddy.lucky4u/swift-4-core-data-part-3-creating-a-singleton-core-data-refactoring-insert-update-delete-9811af2fcf75
    
    func fetchAllPins() -> [Pin] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let pins = [Pin]()
        do {
            if let results = try dataController.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    if let lat = result.value(forKey: "latitude") as? Double, let lon = result.value(forKey: "longitude") as? Double {
                        print("Got \(lat) and \(lon)")
                    }
                    else {
                        print("No latitude/longitude found while getting pins")
                    }
                }
            }
        }
        catch {
            print("Error while getting pin \(error)")
        }
        return pins
    }
    
    
    
    
    //Saving Pins
    func savePin(latitude: Double, longitude: Double) {
        
        if let entityDescription = dataController.managedObjectModel.entitiesByName["Pin"] {
            let managedObject = NSManagedObject.init(entity: entityDescription, insertInto: dataController.managedObjectContext)
            managedObject.setValue(latitude, forKey: "latitude")
            managedObject.setValue(longitude, forKey: "longitude")
            if (dataController.managedObjectContext.hasChanges) {
                do {
                    try dataController.managedObjectContext.save()
                } catch {
                    print("Error while saving pin: \(error)")
                }
            }
        }
    }
    
    
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //Method implemented to respond to taps
    /*    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView) {
     mapView.deselectAnnotation(view.annotation, animated: true)
     
     do {
     let app = UIApplication.shared
     if let toOpen = view.annotation?.subtitle! {
     app.openURL(URL(string: toOpen)!)
     }
     }
     print("selected")
     let controller = storyboard?.instantiateViewController(withIdentifier: "photoviewcontroller") as! PhotoAlbumViewController
     //controller.pin = annotations.
     self.navigationController?.pushViewController(controller, animated: true)
     }*/
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
        let selectedPin = view.annotation as? MKPointAnnotation
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "photoviewcontroller") as! PhotoAlbumViewController
        
        controller.latitude = selectedPin?.coordinate.latitude ?? 0
        controller.longitude = selectedPin?.coordinate.longitude ?? 0
        navigationController?.pushViewController(controller, animated: true)
    }


//end of TravelLocationsViewController
}
