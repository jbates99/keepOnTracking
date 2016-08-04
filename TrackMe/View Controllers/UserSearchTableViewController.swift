//
//  UserSearchTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/14/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class UserSearchTableViewController: UITableViewController {
    
    let notificationController = NotificationController.sharedInstance
    
    var users: [CKDiscoveredUserInfo] {
        return notificationController.discoveredRecords
    }
    
    // MARK: - Computed Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUsers()
        notificationController.requestAccess()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = users.count
        if count == 0 {
            tableView.emptyMessage("None of your contacts have this app.  Ask them to download it in order to make connections.", viewController: self)
            return 0
        } else if count >= 1 {
            tableView.removeMessage(self)
            return count
        } else {
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("requestCell", forIndexPath: indexPath) as! FollowUserTableViewCell
        let user = users[indexPath.row]
        cell.updateWithUser(user)
        cell.delegate = self
        
        return cell
    }
    
    func setUpUsers() {
        notificationController.discoverUsers { success in
            if success {
                Dispatch.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension UserSearchTableViewController: FollowUserTableViewCellDelegate {
    func buttonCellButtonTapped(sender: FollowUserTableViewCell) {
        let indexPath = tableView.indexPathForCell(sender)!
        let user = users[indexPath.row]
        guard let recordID = user.userRecordID else { return }
        FollowingController.sharedController.retrieveFollowingRequests(by: recordID) { (returnedRecords) in
            if let returnedRecords = returnedRecords {
                if returnedRecords.count == 0 {
                    FollowingController.sharedController.createFollowing(recordID)
                } else {
                    return
                }
            } else {
                FollowingController.sharedController.createFollowing(recordID)
            }
        }
    }
}
