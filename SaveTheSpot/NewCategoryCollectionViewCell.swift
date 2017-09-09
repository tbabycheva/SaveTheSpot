//
//  NewCategoryCollectionViewCell.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/28/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

class NewCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.cornerRadius = tagImageView.frame.size.width/2
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor.neonYellow.cgColor
                self.tagImageView.alpha = 1
            } else {
                self.layer.cornerRadius = tagImageView.frame.size.width/2
                self.layer.borderWidth = 0.0
                self.layer.borderColor = UIColor.clear.cgColor
                self.tagImageView.alpha = 0.65
            }
        }
    }
}
