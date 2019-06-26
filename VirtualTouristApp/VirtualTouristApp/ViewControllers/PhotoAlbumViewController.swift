//
//  PhotoAlbumViewController.swift
//  VirtualTouristApp
//
//  Created by Rosario A Robinson on 6/4/19.
//  Copyright © 2019 Rosario Robinson. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData


class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    //MARK: OUTLETS
    @IBOutlet weak var zoomMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noPhotosLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    
    var pin: Pin!
    var photo: FlickrPhoto!
    
    var dataController: DataController!
    var viewContext: DataController!
    var appDelegate: AppDelegate!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var fetchedResultsController:NSFetchedResultsController<FlickrPhoto>!
    
    //Fetched Results View Controller
    //commented out due to crash at launch from line(s) 47-53
    /*func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<FlickrPhoto> = FlickrPhoto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if (pin) != nil {
            let predicate = NSPredicate(format: "pin == %@", pin!)
            fetchRequest.predicate = predicate
        }
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }*/
    
    //LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        collectionView.allowsMultipleSelection = true
        //dataController = appDelegate.dataController
        //setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setupFetchedResultsController()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //fetchedResultsController = nil
    }

    
    //MARK: ACTIONS
    @IBAction func newCollectionPressed(_ sender: Any) {
        
        //setupFetchedResultsController()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    
    }
    
    //grab photos from Flickr API
    func grabFlickrPhotos(){
        
        //error: Cannot convert value of type '((AnyObject?, NSError?) -> Void).Type' to expected argument type '(AnyObject?, NSError?) -> Void'
        //FlickrClient.sharedInstance().taskForGetPhotosForPin(latitude: latitude, longitude: longitude, completionHandlerForGetPhotosForPin: (AnyObject?, NSError?) -> Void)
        /*ParseClient.shared.doSearchPhotos(latitude: latitude, longitude: longitude, currentPage: currentPage, completion: { (data, error) in
         
         if error != nil {
         //show an error message
         
         }else {
         // process the data on UI
         }
         }
         
         })
         
         
         }*/
    }

    
    
    //mapview for pin
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
    
    
    //MARK: Collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoviewcontroller", for: indexPath) as! PhotoAlbumCollectionViewCell
        let photocell = fetchedResultsController.fetchedObjects![indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.cellForItem(at: indexPath) as! PhotoAlbumCollectionViewCell
    }
    
    
}

extension PhotoAlbumViewController :NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        default: ()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: collectionView.insertSections(indexSet)
        case .delete: collectionView.deleteSections(indexSet)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }

    
}

