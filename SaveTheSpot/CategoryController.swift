//
//  CategoryController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/18/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import Foundation
import CoreData

class CategoryController {
    
    // MARK: - Properties
    
    static let shared = CategoryController()
    
    var allCategories: [CategoryMO] {
        
        let request: NSFetchRequest<CategoryMO> = CategoryMO.fetchRequest()
        
        let allCategories = (try? CoreDataStack.context.fetch(request)) ?? []
        
        return allCategories
    }
    
    var availableIcons: [String] = [] {
        didSet {
            saveAvailableIconsToUserDefaults()
        }
    }
    
    init() {
        if UserDefaults.standard.bool(forKey: "defaultCategoriesAreSaved") == false {
            saveDefaultCategoriesToPersistentStore()
        }
        
        if UserDefaults.standard.bool(forKey: "allIconsAreSaved") == false {
            saveIconsToPersistentStore()
        }
        
        self.availableIcons = loadFromUserDefaults()
    }
    
    // Save constants to UserDefaults the first time the app is open
    
    func saveDefaultCategoriesToPersistentStore() {
        _ = Constants.defaultCategories
        saveToPersistentStore()
        UserDefaults.standard.set(true, forKey: "defaultCategoriesAreSaved")
    }
    
    func saveIconsToPersistentStore() {
        saveAllIconsToUserDefaults()
        UserDefaults.standard.set(true, forKey: "allIconsAreSaved")
    }
}


// MARK: - UserDefaults

extension CategoryController {
    
    func saveAllIconsToUserDefaults() {
        UserDefaults.standard.set(Constants.allIcons, forKey: "iconNames")
    }
    
    func saveAvailableIconsToUserDefaults() {
        UserDefaults.standard.set(availableIcons, forKey: "iconNames")
    }
    
    func loadFromUserDefaults() -> [String] {
        
        guard let availableIcons = UserDefaults.standard.object(forKey: "iconNames") as? [String] else { return []}
        return availableIcons
    }
}


// MARK: - CoreData

extension CategoryController {
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("There was an error saving: \(error)")
        }
    }
}
