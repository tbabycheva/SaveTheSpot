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
    
    // MARK: - Action Functions

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = tagName.text else { return }
        
        if iconName.characters.count == 0 {
            alert(title: "Pick an icon for this tag please")
        } else if name.characters.count == 0  {
            alert(title: "Give this tag a name first")
        } else if CategoryController.shared.categoryNames.contains(name) {
            alert(title: "Looks like this tag already exists")
        } else {
            CategoryController.shared.createCategory(withName: name, iconName: iconName)
            
            if let index = CategoryController.shared.availableIcons.index(of: "\(iconName)") {
                CategoryController.shared.availableIcons.remove(at: index)
                CategoryController.shared.saveAvailableIconsToUserDefaults()
                dismiss(animated: true, completion: nil)
            }
        }
        delegate?.saveCategoryWasTapped()
    }
    
    // MARK: - Helper Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = tagName.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
