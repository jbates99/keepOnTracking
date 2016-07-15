//
//  FollowUserTableViewCell.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/12/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class FollowUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    // MARK: - Complete Button Drawing Properties
    
    var delegate: FollowUserTableViewCellDelegate?

    @IBAction func requestButtonTapped(sender: AnyObject) {
        
    }
    
}

protocol FollowUserTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}

extension FollowUserTableViewCell {
    
    func updateWithUser(userInfo: CKDiscoveredUserInfo) {
        nameLabel.text = userInfo.displayContact?.givenName
    
    }
}

