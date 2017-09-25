//
//  AddCategoryCollectionViewCell.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 9/24/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

protocol AddCategoryCollectionViewCellDelegate: class {
    func addCategoryButtonWasTapped(cell: AddCategoryCollectionViewCell)
}

class AddCategoryCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    weak var delegate: AddCategoryCollectionViewCellDelegate?
    
    @IBAction func addCategoryButtonTapped(_ sender: Any) {
        delegate?.addCategoryButtonWasTapped(cell: self)
    }
}
