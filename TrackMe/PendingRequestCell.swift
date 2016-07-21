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
    
    func setUpCellWithRecord(record: CKRecord) {
        guard let creatorRecordID = record.creatorUserRecordID else  { return }
        cloudKitManager.fetchUsernameFromRecordID(creatorRecordID) { givenName, familyName in
            if let givenName = givenName, familyName = familyName {
                Dispatch.main.async {
                    self.nameLabel.text = "\(givenName) \(familyName)"
                }
            } else {
                AlertController.displayError(nil, withMessage: "Error fetching UserName")
            }
        }
    }
    
}
