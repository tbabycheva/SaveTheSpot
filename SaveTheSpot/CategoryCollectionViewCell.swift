//
//  CategoryCollectionViewCell.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/16/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

protocol CategoryCollectionViewCellDelegate: class {
    func deleteCategory(cell: CategoryCollectionViewCell)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CategoryCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryLabel.numberOfLines = 0
        self.categoryLabel.lineBreakMode = .byWordWrapping
        self.categoryLabel.preferredMaxLayoutWidth = 80
        self.categoryLabel.sizeToFit()
    }
    
    func showDeleteButton() {
        deleteButton.isHidden = false
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    @IBAction func deleteButtonDidPress(sender: UIButton) {
        delegate?.deleteCategory(cell: self)
    }
}

