//
//  RequestsViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/19/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class RequestsViewController: UITableViewController {
    
    var queryResults: [CKRecord]?
    
    @IBOutlet weak var hiddenView: UIView!
    
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
        setUpPendingDataSource()
        hiddenView.backgroundColor = AppearanceController.offWhite
        
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = filteredResults?.count ?? 0
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
        let cell = tableView.dequeueReusableCellWithIdentifier(PendingRequestCell.reuseIdentifier) as!PendingRequestCell
        guard let record = filteredResults?[indexPath.row] else { return UITableViewCell() }
        guard let userInfo = NotificationController.sharedInstance.creatorUserInfo(for: record) else { return UITableViewCell() }
        cell.setUpCell(with: record, and: userInfo)
        cell.delegate = self
        return cell
    }
    
    func setUpPendingDataSource() {
        let sharedController = FollowingController.sharedController
        guard let currentUserID = sharedController.currentUserRecordID else { return }
        sharedController.retrieveFollowingsRequestsByStatus(0, recordID: currentUserID) { returnedRecords in
            guard let returnedRecords = returnedRecords else { return }
            self.queryResults = returnedRecords
            
            Dispatch.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension RequestsViewController: PendingRequestCellDelegate {
    func acceptButtonPressed(sender: PendingRequestCell) {
        guard let indexPath = tableView.indexPathForCell(sender), filteredResults = filteredResults else { return }
        let record = filteredResults[indexPath.row]
        guard let following = Following(cloudKitRecord: record) else { return }
        FollowingController.sharedController.updateFollowing(following, status: Following.Status.accepted)
        tableView.reloadData()
    }
    
    func declineButtonPressed(sender: PendingRequestCell) {
        guard let indexPath = tableView.indexPathForCell(sender), filteredResults = filteredResults else { return }
        let record = filteredResults[indexPath.row]
        guard let following = Following(cloudKitRecord: record) else { return }
        FollowingController.sharedController.updateFollowing(following, status: Following.Status.denied)
        tableView.reloadData()
    }
}
