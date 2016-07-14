//
//  ProfileTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/12/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class ProfileTableViewController: UITableViewController {
    
    private let notificationController = NotificationController()
    var users: [CKDiscoveredUserInfo] = []
    var followedUsers: [String]? {
        return UserController.sharedInstance.currentUser?.following
    }
    
    @IBOutlet weak var currentUserProfilePic: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUsers()
        
        notificationController.requestAccess()
        
        
        if let currentUser = UserController.sharedInstance.currentUser {
            currentUserNameLabel.text = currentUser.name
        }
        
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followCell", forIndexPath: indexPath) as! FollowUserTableViewCell
        let user = users[indexPath.row]
        cell.updateWithUser(user)
        cell.delegate = self
        
        return cell
    }
  
    func setUpUsers() {
            notificationController.discoverUsers { (users) in
            self.users = users
                Dispatch.main.async {
                    self.tableView.reloadData()
                }
      
        }
    }
    
}

extension ProfileTableViewController: FollowUserTableViewCellDelegate {
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        let indexPath = tableView.indexPathForCell(sender)!
        let user = users[indexPath.row]
        MessageController.subscribeForPushNotifications(String(user.userRecordID))
    }
}
