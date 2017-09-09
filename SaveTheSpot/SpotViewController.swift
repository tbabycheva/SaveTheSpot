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
    
    // MARK: - Properties
    
    var spot: SpotMO? {
        didSet {
            updateViews()
        }
    }
    
    var spotCategories: [CategoryMO] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        spotCategoriesCollectionView.dataSource = self
        
        updateViews()
        
        if let cvl = spotCategoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            cvl.estimatedItemSize = CGSize(width: 100, height: 35)
        }
    }
    
    func updateViews() {
        guard let spot = spot, self.isViewLoaded else { return }
        
        nameLabel.text = spot.name
        addressLabel.text = spot.address
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func editCategoriesButtonTapped(_ sender: Any) {
    
    }
}
