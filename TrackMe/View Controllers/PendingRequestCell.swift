//
//  PendingRequestCell.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/20/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

protocol PendingRequestCellDelegate {
    
    func acceptButtonPressed(sender: PendingRequestCell)
    func declineButtonPressed(sender: PendingRequestCell)
    
}

class PendingRequestCell: UITableViewCell {
    
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    static let reuseIdentifier = "requestCell"
    
    let notificationController = NotificationController.sharedInstance
    
    var delegate: PendingRequestCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBAction func acceptButtonTapped(sender: AnyObject) {
        self.delegate?.acceptButtonPressed(self)
        
    }

    @IBAction func declineButtonTapped(sender: AnyObject) {
        self.delegate?.declineButtonPressed(self)
    }
    
}

extension PendingRequestCell {
    
    func setUpCell(with record: CKRecord, and userInfo: CKDiscoveredUserInfo) {
        guard let contact = userInfo.displayContact else { return }
        declineButton.backgroundColor = UIColor.orangeRed
        acceptButton.backgroundColor = UIColor.darkGreen
        nameLabel.textColor = UIColor.darkGreen
        nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
    }
    
}
