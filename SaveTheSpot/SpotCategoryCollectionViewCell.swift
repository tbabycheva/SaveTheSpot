//
//  SpotCategoryCollectionViewCell.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/19/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

protocol SpotCategoryCollectionViewCellDelegate: class {
    func removeCategory(cell: SpotCategoryCollectionViewCell)
}

class SpotCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    weak var delegate: SpotCategoryCollectionViewCellDelegate?
    
    @IBAction func deleteCategoryButtonTapped(_ sender: Any) {
        delegate?.removeCategory(cell: self)
    }
}
