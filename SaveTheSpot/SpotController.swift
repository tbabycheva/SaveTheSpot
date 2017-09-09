//
//  SpotController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/18/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class SpotController {
    
    static let shared = SpotController()
    
    static let spotsWereUpdatedNotification = Notification.Name("spotsWereUpdated")
    
    var spots: [SpotMO] {
        
        let fetchRequest: NSFetchRequest<SpotMO> = SpotMO.fetchRequest()
        
        do {
            let results = try CoreDataStack.context.fetch(fetchRequest)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: SpotController.spotsWereUpdatedNotification, object: self)
            }
            return results.sorted(by: {
                guard let firstSpotName = $0.name else { return false }
                guard let secondSpotName = $1.name else { return true }
                return firstSpotName < secondSpotName }
            )
        } catch {
            print("Error fetching SpotMO from persistentStore")
            return []
        }
    }
    
    var spotsToDisplay: [SpotMO] = [] {
        didSet {
        }
    }
    
    init() {
        spotsToDisplay = spots
    }
}

// CoreData

extension SpotController {
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("There was an error saving: \(error)")
        }
    }
}
