//
//  FollowedUserUpdatesTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/12/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class FollowedUserUpdatesTableViewController: UITableViewController {
    
    var followedUsers = UserController.sharedInstance.currentUser?.following
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setUpUpdates() {
        guard let followedUsers = followedUsers else { return }
        for userID in followedUsers {
            CKContainer.defaultContainer().publicCloudDatabase.fetchSubscriptionWithID(userID, completionHandler: { (response, error) in
                
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = followedUsers?.count else { return 0 }
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("updateCell", forIndexPath: indexPath)
        
        return cell
    }
    
}
