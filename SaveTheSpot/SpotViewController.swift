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
    
    // MARK: - Action Functions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let spot = spot else { return }
        
        if spotCategories.count == 0 {
            let characterAlert = UIAlertController(title: "Please attach at least one tag to this spot", message: "", preferredStyle: .alert)
            characterAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(characterAlert, animated: true, completion: nil)
            
        } else {
            
            // Make a new spot with the core data stack's context, add categories and save to CoreData
            if let name = spot.name, let address = spot.address {
                
                let CoreDataSpot = SpotController.shared.create(spotWithName: name, address: address, placemark: spot.placemark, context: CoreDataStack.context)
                
                for category in spotCategories {
                    SpotController.shared.addCategory(category: category, toSpot: CoreDataSpot)
                }
            }
            SpotController.shared.saveToPersistentStore()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        SpotController.shared.showAll()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editCategoriesButtonTapped(_ sender: Any) {
        toggleEditMode()
    }
    
    // MARK: - Helper Functions
    
    var inEditingMode: Bool = false
    
    func toggleEditMode() {
        let cellCount = categoriesCollectionView.numberOfItems(inSection: 0)
        
        if cellCount != 0 {
            for cellNumber in 0...(cellCount-1) {
                let indexPath = IndexPath(row: cellNumber, section: 0)
                guard let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { continue }
                
                if inEditingMode == false {
                    cell.showDeleteButton()
                    editModeButton.setImage(#imageLiteral(resourceName: "save-category-button"), for: .normal)
                } else {
                    cell.hideDeleteButton()
                    editModeButton.setImage(#imageLiteral(resourceName: "edit-category-button"), for: .normal)
                }
            }
            inEditingMode = !inEditingMode
        }
    }
}
