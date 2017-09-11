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
        
        if let flowLayout = spotCategoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 35)
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


// MARK: - Collection View Data Source & Delegate

extension SpotViewController: UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView === spotCategoriesCollectionView {
            return spotCategories.count
        } else if collectionView === categoriesCollectionView {
            let cellCount = CategoryController.shared.allCategories.count
            if cellCount == 0 {
                inEditingMode = false
                editModeButton.setImage(#imageLiteral(resourceName: "edit-category-button"), for: .normal)
            }
            return cellCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView === categoriesCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return CategoryCollectionViewCell() }
            
            let category = CategoryController.shared.allCategories[indexPath.row]
            
            cell.categoryLabel.text = category.name
            if let iconName = category.iconName {
                cell.iconView.image = UIImage(named: iconName)
            }
            cell.delegate = self
            
            if inEditingMode {
                cell.showDeleteButton()
            } else {
                cell.hideDeleteButton()
            }
            
            return cell
            
        } else if collectionView === spotCategoriesCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spotCategoryCell", for: indexPath) as? SpotCategoryCollectionViewCell else { return SpotCategoryCollectionViewCell() }
            
            let category = spotCategories[indexPath.row]
            
            cell.categoryLabel.text = category.name
            
            if let iconName = category.iconName {
                cell.iconView.image = UIImage(named: iconName)
            }
            
            cell.delegate = self
            
            return cell
            
        } else { return CategoryCollectionViewCell() }
    }
}

extension SpotViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard !inEditingMode else { return }
        
        let category = CategoryController.shared.allCategories[indexPath.row]
        
        if !spotCategories.contains(category) {
            spotCategories.append(category)
        }
        spotCategoriesCollectionView.reloadData()
        spotCategoriesCollectionView.collectionViewLayout.invalidateLayout()

    }
}

// MARK: - Delegate Methods

extension SpotViewController: SpotCategoryCollectionViewCellDelegate {
    
    func removeCategory(cell: SpotCategoryCollectionViewCell) {
        
        guard let indexPath = spotCategoriesCollectionView.indexPath(for: cell) else { return }
        
        spotCategories.remove(at: indexPath.row)
        
        spotCategoriesCollectionView.reloadData()
        spotCategoriesCollectionView.collectionViewLayout.invalidateLayout()

    }
}

extension SpotViewController: CategoryCollectionViewCellDelegate {
    
    func deleteCategory(cell: CategoryCollectionViewCell) {
        
        guard let index = categoriesCollectionView.indexPath(for: cell) else { return }
        
        let category = CategoryController.shared.allCategories[index.item]
        
        if CategoryController.shared.containsSpots(category: category) {
            
            alert()
            
        } else {
            
            CategoryController.shared.deleteCategory(category: category)
            
            if let iconName = category.iconName {
                CategoryController.shared.availableIcons.append(iconName)
                CategoryController.shared.saveAvailableIconsToUserDefaults()
            }
        }
        
        categoriesCollectionView.reloadData()
    }
    
    func alert() {
        let categoryContainsSpotsAlert = UIAlertController(title: "Sorry, can't remove a tag that has spots attached to it", message: "", preferredStyle: .alert)
        categoryContainsSpotsAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(categoryContainsSpotsAlert, animated: true, completion: nil)
    }
}

extension SpotViewController: CustomCategoryViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewTagModal" {
            
            if inEditingMode {
                toggleEditMode()
            }
            
            let destinationVC = segue.destination as? CustomCategoryViewController
            destinationVC?.delegate = self
        }
    }
    
    func saveCategoryWasTapped() {
        categoriesCollectionView.reloadData()
    }
}

