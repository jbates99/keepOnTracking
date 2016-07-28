//
//  FamilyMembersTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/21/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class FamilyMembersTableViewController: UITableViewController {
    
    var queryResults: [CKRecord]?
    
    var messagesResults = [Message]()
    
    var filteredResults: [CKRecord]? {
        guard let queryResults = queryResults else { return nil }
        return queryResults.filter { $0.creatorUserRecordID?.recordName == "__defaultOwner__" }
    }
    
    var followingResults: [Following]? {
        guard let filteredResults = filteredResults else { return nil }
        var followingResults = [Following]()
        for result in filteredResults {
            if let following = Following(cloudKitRecord: result) {
                followingResults.append(following)
            } else {
                print("Record type was not following")
            }
        }
        return followingResults
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpDataSource()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredResults?.count ?? 0
        if count == 0 {
            tableView.emptyMessage("You currently have no connections. Press the add button to create your first!", viewController: self)
            return 0
        } else if count >= 1 {
            tableView.removeMessage(self)
            return count
        } else {
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("updateCell", forIndexPath: indexPath) as! ConnectionTableViewCell
        
        guard let record = filteredResults?[indexPath.row] else { return UITableViewCell() }
        guard let userInfo = NotificationController.sharedInstance.followingUserInfo(for: record) else { return UITableViewCell() }
        
        cell.setUpCell(with: record, userInfo: userInfo, and: messagesResults[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func setUpmessages() {
        guard let filteredResults = filteredResults else { return }
        for result in filteredResults {
            MessageController.sharedController.fetchLatestUserUpdateMessage(result.recordID) { (message) in
                guard let messages = message else { return }
                let newMessage = messages[1]
                self.messagesResults.append(newMessage)
                Dispatch.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setUpDataSource() {
        FollowingController.retrieveFollowingsRequestsByStatusForUser(1) { returnedRecords in
            guard let returnedRecords = returnedRecords else { return }
            self.queryResults = returnedRecords
            
            Dispatch.main.async {
                self.tableView.reloadData()
            }
        }
    }
}


extension FamilyMembersTableViewController: ConnectionTableViewCellDelegate {
    func notifyMeButtonPressed(sender: ConnectionTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(sender), filteredResults = filteredResults else { return }
        let record = filteredResults[indexPath.row]
        MessageController.subscribeForPushNotifications(String(record.creatorUserRecordID))
        setUpDataSource()
        tableView.reloadData()
    }
}
