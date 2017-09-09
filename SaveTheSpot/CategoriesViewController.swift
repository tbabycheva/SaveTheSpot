//
//  CategoriesViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/10/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties and Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myCategoriesLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var showAllButton: UIButton!
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.backgroundColor = .oatmeal
        spotsNoSpotsToggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideStatusBar()
        spotsNoSpotsToggle()
    }
    
    // MARK: - Helper Functions
    
    func spotsNoSpotsToggle() {
        
        if SpotController.shared.spotsToDisplay.isEmpty{
            backgroundImage.isHidden = false
            showAllButton.isHidden = true
        } else {
            backgroundImage.isHidden = true
            showAllButton.isHidden = false
        }
    }
    
    func hideStatusBar() {
        guard let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
            return
        }
        statusBar.isHidden = true
    }
    
    // MARK: - Action Functions
    
    @IBAction func showAllButtonTapped(_ sender: Any) {
        SpotController.shared.showAll()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myMapButtonTapped(_ sender: Any) {
        SpotController.shared.showAll()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
