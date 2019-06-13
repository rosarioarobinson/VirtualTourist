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


class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var zoomMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var noPhotosLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    
    
    var pin: Pin!
    
    var dataController: DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    //Fetched Results View Controller
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", self.pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin)-pins")
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    //Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }

    
    //MARK: Actions
    @IBAction func newCollectionPressed(_ sender: Any) {
        
        setupFetchedResultsController()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    
    
    
    
    //MARK: Collection views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //dequeue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoviewcell", for: indexPath) as! PhotoAlbumCollectionViewCell

        
        //cell default info
        cell.imageView!.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoAlbumCollectionViewCell
    }
    
    
}
