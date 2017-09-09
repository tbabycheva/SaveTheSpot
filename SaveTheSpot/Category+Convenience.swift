//
//  Category+Convenience.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/23/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import Foundation
import CoreData

extension CategoryMO {
    
    convenience init(name: String,
                     iconName: String,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.iconName = iconName
    }
}
