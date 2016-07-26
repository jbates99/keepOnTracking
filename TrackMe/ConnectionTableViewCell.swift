//
//  ConnectionTableViewCell.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/26/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

protocol ConnectionTableViewCellDelegate {
    
    func notifyMeButtonPressed(sender: ConnectionTableViewCell)
    
}

class ConnectionTableViewCell: UITableViewCell {
    
    var delegate: ConnectionTableViewCellDelegate?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userUpdateLabel: UILabel!
    
    @IBOutlet weak var notifyMeButton: UIButton!
    
    @IBAction func notifyMeButtonPressed(sender: AnyObject) {
        self.delegate?.notifyMeButtonPressed(self)
    }
    
    func setUpCell(with record: CKRecord, userInfo: CKDiscoveredUserInfo, and message: Message?) {
        guard let contact = userInfo.displayContact else { return }
        
        userUpdateLabel.textColor = AppearanceController.darkGreen
        if message != nil {
            userUpdateLabel.text = message?.messageText
        } else {
            userUpdateLabel.text = "No current location update for user \(contact.givenName)"
        }
        nameLabel.textColor = AppearanceController.darkGreen
        nameLabel.text = "\(contact.givenName) \(contact.familyName)"
    }
}


