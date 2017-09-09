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
    
    func spotsWith(category: CategoryMO) -> [SpotMO] {
        
        var spotsWithCategory: [SpotMO] = []
        
        for spot in self.spots {
            
            guard let categories = spot.categories?.array as? [CategoryMO] else { return [] }
            
            if categories.contains(category) { spotsWithCategory.append(spot) }
        }
        return spotsWithCategory
    }
    
    func showAll() {
        spotsToDisplay = spots
    }
    
    // CRUD
    
    // used in Location VC when user chooses a spot from the list of search results
    func create(spotWithName name: String, address: String, placemark: MKPlacemark, context: NSManagedObjectContext?) -> SpotMO {
        let spot = SpotMO(name: name, address: address, placemark: placemark, context: context)
        return spot
    }
    
    // used when Save button tapped in Spot VC
    func addCategory(category: CategoryMO, toSpot spot: SpotMO) {
        
        guard var categorySpots = category.spots?.array as? [SpotMO] else { return }
        
        guard let mutableCategories = spot.categories?.mutableCopy() as? NSMutableOrderedSet else { return }
        
        mutableCategories.add(category)
        
        spot.categories = mutableCategories
        
        categorySpots.append(spot)
        let orderedSet = NSOrderedSet(array: categorySpots)
        category.spots = orderedSet
    }
    
    // used in category swipe to delete
    // remove category from spot categories
    func remove(category: CategoryMO, fromSpot spot: SpotMO) {
        
        // remove spot for category.spots
        guard let mutableCategorySpots = category.spots?.mutableCopy() as? NSMutableOrderedSet else { return }
        mutableCategorySpots.remove(spot)
        category.spots = mutableCategorySpots
        
        // remove category from spot.categories
        guard let mutableCategories = spot.categories?.mutableCopy() as? NSMutableOrderedSet else { return }
        mutableCategories.remove(category)
        spot.categories = mutableCategories
        
        if spot.categories?.count == 0 {
            remove(spot: spot)
        }
        
        saveToPersistentStore()
    }
    
    // used when Cancel button tapped in Spot VC
    // remove spot from spots
    func remove(spot: SpotMO){
        spot.managedObjectContext?.delete(spot)
        saveToPersistentStore()
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
