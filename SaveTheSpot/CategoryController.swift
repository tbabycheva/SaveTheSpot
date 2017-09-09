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
    
    // MARK: - CRUD
    
    // used in Categories Collection View
    func createCategory(withName name: String, iconName: String) {
        let _ = CategoryMO(name: name, iconName: iconName)
        saveToPersistentStore()
    }
    
    // used in Categories Collection View
    func deleteCategory(category: CategoryMO) {
        if category.spots?.count != 0 {
        } else {
            guard let iconName = category.iconName else { return }
            CategoryController.shared.availableIcons.append(iconName)
            category.managedObjectContext?.delete(category)
            saveIconsToPersistentStore()
            saveToPersistentStore()
        }
    }
    
    // called before deleting a category
    func containsSpots(category: CategoryMO) -> Bool {
        if category.spots?.count == 0 {
            return false
        } else {
            return true   // present alert "Can't remove a category containing spots"
        }
    }
    
    // used in modal Category View
    var allCategoriesUsedBySpotsSorted: [CategoryMO] {
        
        var categoriesUsedBySpots: [CategoryMO] = []
        
        for spot in SpotController.shared.spots {
            
            guard let categories = spot.categories?.array as? [CategoryMO] else { return [] }
            
            for category in categories {
                if !categoriesUsedBySpots.contains(category) { categoriesUsedBySpots.append(category) }
            }
        }
        
        return categoriesUsedBySpots.sorted(by: {
            guard let firstSpotName = $0.name else { return false }
            guard let secondSpotName = $1.name else { return true }
            return firstSpotName < secondSpotName})
    }
    
    var categoryNames: [String] {
        get {
            return allCategoriesUsedBySpotsSorted.flatMap { $0.name }
        }
    }
    
    var iconNames: [String] {
        get {
            return allCategoriesUsedBySpotsSorted.flatMap { $0.iconName }
        }
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
