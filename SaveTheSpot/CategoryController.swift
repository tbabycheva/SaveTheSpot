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
