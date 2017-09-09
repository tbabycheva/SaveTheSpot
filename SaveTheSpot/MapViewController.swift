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
    
}

extension MapViewController {
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}
