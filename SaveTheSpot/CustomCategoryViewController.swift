//
//  CustomCategoryViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/28/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

protocol CustomCategoryViewControllerDelegate: class {
    func saveCategoryWasTapped()
}

class CustomCategoryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var customCategoryCollectionView: UICollectionView!
    @IBOutlet weak var tagName: UITextField!
    
    // MARK: - Properties
    
    var category: CategoryMO?
    var iconName: String = ""
    let limitLength = 25
    
    weak var delegate: CustomCategoryViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customCategoryCollectionView.dataSource = self
        customCategoryCollectionView.delegate = self
        
        modalView.layer.cornerRadius = 15.0
        self.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.75)
        tagName.delegate = self
        
        CategoryController.shared.availableIcons = CategoryController.shared.loadFromUserDefaults()
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}
