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
    
   
    var dataController: DataController!
    var sharedContext: NSManagedObjectContext!
    var appDelegate: AppDelegate!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var editBarButton: UIBarButtonItem!
    var pin = [Pin]()
    var annotations = [MKPointAnnotation]()
    

    //Fetched Results View Controller
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "String", ascending: false)
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        
        //code for long press gesture pin
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(annotationPins(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(gestureRecognizer)
        
        mapView.delegate = self
        //edit button
        navigationItem.rightBarButtonItem = editButtonItem
        editPin.isEnabled = true
        
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

   /* @IBAction func pinsLongPressRecognizer(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {return}
        
        let pressPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(pressPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        
        if gestureRecognizer.state == .ended{
            self.mapView.addAnnotation(annotations as! MKAnnotation)
        }
        
    }*/
    
    @IBAction func editPinsPressed(sender: UIBarButtonItem ) {
    
        if isEditing {
            editBarButton.title = "Edit"
            editPin.isEnabled = true
            self.setEditing(false, animated: true)
        } else {
            editBarButton.title = "Done"
            editPin.isEnabled = false
            self.setEditing(true, animated: true)
        }
    
    }
    
    @objc func annotationPins(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {return}
        
        let pressPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(pressPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        
        if gestureRecognizer.state == .ended{
            self.mapView.addAnnotation(annotations as! MKAnnotation)
        }
        
    }
    
    

    }


func fetchAllPins() -> [Pin] {
    
    /*Before you can do anything with Core Data, you need a managed object context. */
    let managedContext = CoreDataStack.getContext()
    
    /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
     
     Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
     */
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pin")
    
    /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
    do {
        let pin = try managedContext.fetch(fetchRequest)
        return (pin as? [Pin])!
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
        return [Pin]()
    }
}



    
    //Saving Pins
    func addSavedPins() {
         //Pin = fetchAllPins()
        
        /*for pin in fetchAllPins() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            self.mapView.addAnnotation(annotation as! MKAnnotation)
        }*/
    }
    
    
    
    // MARK: NAVIGATION
    
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbum" {
            let photoAlbumViewController = segue.destination as! PhotoAlbumViewController
            
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        do {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }


