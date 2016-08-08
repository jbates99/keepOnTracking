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
    
    func updateWithUser(userInfo: CKDiscoveredUserInfo, status: Int?) {
        setUpCellAppearence()
        if let displayContact = userInfo.displayContact {
            let name = "\(displayContact.givenName) \(displayContact.familyName)"
            nameLabel.text = name
        } else {
            nameLabel.text = userInfo.displayContact?.givenName
        }
        if status == nil {
            pendingLabel.hidden = true
            buttonLabel.hidden = false
        } else if status == 0 { // Pending
            buttonLabel.hidden = true
            pendingLabel.hidden = false
        } else if status == 1 { // Accepted
            buttonLabel.hidden = true
            pendingLabel.text = "Accepted"
            pendingLabel.hidden = false
        } else if status == 2 { // Denied
            buttonLabel.hidden = true
            pendingLabel.text = "Denied"
            pendingLabel.textColor = UIColor.orangeRed
            pendingLabel.hidden = false
        }
    }
    
    func setUpCellAppearence() {
        buttonLabel.setTitleColor(UIColor.lightGreen, forState: .Normal)
        buttonLabel.layer.borderWidth = 1
        buttonLabel.layer.borderColor = UIColor.lightGreen.CGColor
        buttonLabel.layer.cornerRadius = 5
        buttonLabel.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        pendingLabel.textColor = UIColor.lightGreen
        nameLabel.textColor = UIColor.darkGreen
    }
}
