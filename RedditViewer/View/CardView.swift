//
//  CardView.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/24/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//


import UIKit

@IBDesignable


/// Custom view to give the look of a material card
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.gray
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
