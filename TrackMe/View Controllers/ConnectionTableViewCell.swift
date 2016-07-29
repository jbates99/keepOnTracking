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
    
    func setUpCell(with connection: Connections) {
        if connection.notified == true {
            notifyMeButton.setTitle("Stop Notifications", forState: .Normal)
        } else if connection.notified == false {
            notifyMeButton.setTitle("Notify Me", forState: .Normal)
        }
        
        if let message = connection.message {
            userUpdateLabel.text = message
        } else {
            userUpdateLabel.text = "There are no current location updates for this User"
        }
        
        nameLabel.text = connection.name
        nameLabel.textColor = UIColor.darkGreen
    }
}


