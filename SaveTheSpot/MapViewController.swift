//
//  MapViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/10/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var annotationView: MKAnnotationView?
    
    var selectedPin: MKAnnotation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // Show current user location
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapViewController {
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}
