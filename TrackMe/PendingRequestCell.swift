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
    
    static let reuseIdentifier = "requestCell"
    
    let notificationController = NotificationController.sharedInstance

    let cloudKitManager = CloudKitManager()
    
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
        nameLabel.text = "\(contact.givenName)"
    }
    
}
