//
//  contentTableViewCell.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/24/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit
import Siesta
class contentTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var leftIcon: RemoteImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subReddit: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.adjustsFontSizeToFitWidth = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //configureStatus(isActive: selected)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        configureStatus(isActive: highlighted)
    }

    
    func configureStatus(isActive: Bool) {
        if isActive {
            view.layer.backgroundColor = UIColor.gray.cgColor
        } else {
            view.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
}
