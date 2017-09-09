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
        
        updateViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: SpotController.spotsWereUpdatedNotification, object: nil)
        
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        
        guard self.isViewLoaded else { return }
        
        // Remove old pins
        mapView.removeAnnotations(mapView.annotations)
        
        // Drop pins
        let annotations = SpotController.shared.spotsToDisplay.map { spot -> MKAnnotation in
            
            let annotation = SpotMKPointAnnotation()
            annotation.title = spot.name
            annotation.subtitle = spot.address
            annotation.coordinate = CLLocationCoordinate2D(latitude: spot.placemark.coordinate.latitude, longitude: spot.placemark.coordinate.longitude)
            
            if let category = spot.categories?.firstObject as? CategoryMO, let iconName = category.iconName {
                annotation.iconName = iconName
            }
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
}

// Current user location

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(myLocation, span)
            mapView.setRegion(region, animated: false)
        }
        manager.stopUpdatingLocation()
    }
}

// Display pins on the map

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MySpot"
        
        // exclude the annotation for current user location
        if annotation.isKind(of: MKUserLocation.self) { return nil }
        
        guard let customAnnotation = annotation as? SpotMKPointAnnotation else { return nil }
        var annotationView:MKAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: customAnnotation.iconName)
        }
        return annotationView
    }
}


// MARK: - Action Functions

extension MapViewController {
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Gesture Recognition - Displaying / Dismissing Routes and Bubbles
extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false}
        if view.isKind(of: MKAnnotationView.self) {
            return false
        } else {
            return true
        }
    }
}
