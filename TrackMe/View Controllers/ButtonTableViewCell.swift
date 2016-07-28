//
//  ProjectTableViewCell.swift
//  Task
//
//  Created by Caleb Hicks on 10/18/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit
import CoreLocation

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryLabel: UILabel!
    
    var delegate: ButtonTableViewCellDelegate?
    
    

}

protocol ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}

extension ButtonTableViewCell {
    
    func updateWithLocation(region: CLRegion) {
        primaryLabel.textColor = UIColor.lightGreen
        primaryLabel.text = region.identifier
    }
}

