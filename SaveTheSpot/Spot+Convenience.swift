//
//  Spot+Convenience.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/23/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension SpotMO {
    
    convenience init(name: String,
                     address: String,
                     placemark: MKPlacemark,
                     context: NSManagedObjectContext? = CoreDataStack.context) {
        if let context = context {
            // This is the object that is saved to Core Data
            self.init(context: context)
        } else {
            // This is a temporary model object in memory
            self.init(entity: SpotMO.entity(), insertInto: nil)
        }
        
        self.name = name
        self.address = address
        self.latitude = placemark.coordinate.latitude
        self.longitude = placemark.coordinate.longitude
    }
    
    var placemark: MKPlacemark  {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        return placemark
    }
}
