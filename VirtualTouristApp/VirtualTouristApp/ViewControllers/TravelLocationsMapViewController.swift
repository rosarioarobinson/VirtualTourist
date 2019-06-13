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
    
    //OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editPin: UIBarButtonItem!
    
   
    var pin = [Pin]()
    
    var appDelegate: AppDelegate!
    
    var sharedContext: NSManagedObjectContext!
    
    var dataController: DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    var annotations = [MKPointAnnotation]()
    

    //fetched results view controller
    func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "string", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataController = appDelegate.dataController
        //code for long press gesture pin
        let pinLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(annotationPins(gestureRecognizer:)))
        pinLongPressRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(pinLongPressRecognizer)
        
        mapView.delegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    //MARK: Actions

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
    
    @IBAction func editPinsPressed(_ sender: Any) {
    
        
    
    }
    
    @objc func annotationPins(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {return}
        
        let pressPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(pressPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        
        
        if gestureRecognizer.state == .ended{
            self.mapView.addAnnotation(annotations as! MKAnnotation)
        }
        
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
    
    
    
    // MARK: Navigation
    
func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbum" {
            let photoAlbumViewController = segue.destination as! PhotoAlbumViewController
            
        }
    }
    
    
    //Fetch Pins
    //ERROR OCCURED with 'sharedContext'
    func fetchAllPins() -> [Pin] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let sharedContext = NSManagedObjectContext()
        do {
            //ERROR: Use of unresolved identifier 'sharedContext'
            return try sharedContext.fetch(fetchRequest) as! [Pin]
        } catch {
            print("Error In Fetch!")
            //return [Pin]()
        }
        return [Pin]()
    }
    
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //Method implemented to respond to taps
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }


