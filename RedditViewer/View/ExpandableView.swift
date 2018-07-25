//
//  ExpandableView.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/25/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit

class ExpandableView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Returns the full size to fit the available area
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }
}
