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
    
    private let notificationController = NotificationController()
    private let cloudKitManager = CloudKitManager()
    
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
        return users.count
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
        FollowingController.sharedController.createFollowing(recordID)
    }
}
