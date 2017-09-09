//
//  SpotViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/10/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class SpotViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var spotCategoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editModeButton: UIButton!
    
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func editCategoriesButtonTapped(_ sender: Any) {
    
    }
}
