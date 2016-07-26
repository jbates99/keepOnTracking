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
    
    @IBOutlet weak var hiddenView: UIView!
    
    var queryResults: [CKRecord]?
    var messages = [Message]()
    
    var filteredResults: [CKRecord]? {
        guard let queryResults = queryResults else { return nil }
        return queryResults.filter { $0.creatorUserRecordID?.recordName != "__defaultOwner__" }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenView.backgroundColor = AppearanceController.offWhite
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = queryResults?.count ?? 0
        if count == 0 {
            hiddenView.hidden = false
            return count
        } else if count >= 1 {
            hiddenView.hidden = true
            return count
        } else {
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("updateCell", forIndexPath: indexPath) as! ConnectionTableViewCell
        
        guard let record = filteredResults?[indexPath.row] else { return UITableViewCell() }
        guard let userInfo = NotificationController.sharedInstance.creatorUserInfo(for: record) else { return UITableViewCell() }
        MessageController.sharedController.fetchLatestUserUpdateMessage(record.recordID) { (message) in
            guard let messages = message else { return }
            let newMessage = messages[1]
            cell.setUpCell(with: record, userInfo: userInfo, and: newMessage)
        }
        cell.delegate = self
        return cell
    }
    
    func setUpDataSource() {
        let sharedController = FollowingController.sharedController
        guard let currentUserID = sharedController.currentUserRecordID else { return }
        sharedController.retrieveFollowingsRequestsByStatus(1, recordID: currentUserID) { returnedRecords in
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
