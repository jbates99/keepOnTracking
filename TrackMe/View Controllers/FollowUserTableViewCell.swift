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
    
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    
    var userRecordID: CKRecordID?
    var delegate: FollowUserTableViewCellDelegate?
    
    @IBAction func requestButtonTapped(sender: AnyObject) {
        self.delegate?.buttonCellButtonTapped(self)
        buttonLabel.hidden = true
        pendingLabel.hidden = false
    }
    
}

protocol FollowUserTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: FollowUserTableViewCell)
}

extension FollowUserTableViewCell {
    
    func updateWithUser(userInfo: CKDiscoveredUserInfo) {
        buttonLabel.setTitleColor(UIColor.orangeRed, forState: .Normal)
        pendingLabel.textColor = UIColor.lightGreen
        nameLabel.textColor = UIColor.darkGreen
        nameLabel.text = userInfo.displayContact?.givenName
        
    }
}
