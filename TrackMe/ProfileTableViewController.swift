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
    
    var users: [CKDiscoveredUserInfo] = []
    var followedUsers: [String]? {
        return UserController.sharedInstance.currentUser?.following
    }
    
    @IBOutlet weak var currentUserProfilePic: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationController.requestAccess()
        
        
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
        func discoverUsers(completion: (users: [CKDiscoveredUserInfo]) -> Void) {
            let container = NotificationController.container
            var discoveredUsers: [CKDiscoveredUserInfo] = []
            container.discoverAllContactUserInfosWithCompletionHandler { (users, error) in
                if error != nil {
                    print("Error: \(error)")
                    discoveredUsers = []
                } else if users != nil {
                    guard let users = users else { return }
                    discoveredUsers = users
                }
            }
            completion(users: discoveredUsers)
            dispatch_async(dispatch_get_main_queue()) {
                self.users = discoveredUsers
                self.tableView.reloadData()
            }
            
        }
        
    }
    
}

extension ProfileTableViewController: FollowUserTableViewCellDelegate {
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        
    }
}
