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
    
    var userStatusDictionary = [CKDiscoveredUserInfo: Int]()
    
    var users: [CKDiscoveredUserInfo] {
        return notificationController.discoveredRecords
    }
    
    // MARK: - Computed Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.Progress)
        HUD.dimsBackground = false
        HUD.allowsInteraction = true
        setUpUsers()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUpUserStatusDictionary), name: "discoveredUsers", object: nil)
        notificationController.requestAccess()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
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
        let userStatus = userStatusDictionary[user] ?? nil
        cell.updateWithUser(user, status: userStatus)
        cell.delegate = self
        cell.selectionStyle = .None
        
        return cell
    }
    
    func setUpUsers() {
        notificationController.discoverUsers { success in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("discoveredUsers", object: nil)
            }
        }
    }
    
    func setUpUserStatusDictionary() {
        let group = dispatch_group_create()
        for user in users {
            dispatch_group_enter(group)
            guard let recordID = user.userRecordID else { dispatch_group_leave(group); break }
            FollowingController.sharedController.retrieveFollowingRequests(by: recordID, completion: { (returnedRecords) in
                if let returnedRecords = returnedRecords {
                    if returnedRecords.count > 0 && returnedRecords.count < 2  {
                        guard let record = returnedRecords.first, following = Following(cloudKitRecord: record) else { return }
                        self.userStatusDictionary[user] = following.status
                        dispatch_group_leave(group)
                    }
                }
            })
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            self.tableView.reloadData()
            HUD.hide()
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
