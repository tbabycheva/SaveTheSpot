//
//  CustomCategoryViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/28/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

class CustomCategoryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var customCategoryCollectionView: UICollectionView!
    @IBOutlet weak var tagName: UITextField!
    
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
}
