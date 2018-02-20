//
//  PressToDeleteAnimation.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 9/25/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit

final class PressToDeleteAnimationManager: NSObject {
    
    // MARK: - Properties
    var longGesture: UILongPressGestureRecognizer!
    var movingIndexPath: IndexPath?
}
