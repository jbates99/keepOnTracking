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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSource()
        
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryResults?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PendingRequestCell.reuseIdentifier) as!PendingRequestCell
        guard let record = queryResults?[indexPath.row] else { return UITableViewCell() }
        cell.setUpCellWithRecord(record)
        cell.delegate = self
        return cell
    }
    
    func setUpDataSource() {
        let sharedController = FollowingController.sharedController
        guard let currentUserID = sharedController.currentUserRecordID else { return }
        sharedController.retrieveFollowingsRequests(currentUserID) { returnedRecords in
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
        guard let indexPath = tableView.indexPathForCell(sender), queryResults = queryResults else { return }
        let record = queryResults[indexPath.row]
        guard let following = Following(cloudKitRecord: record) else { return }
        FollowingController.sharedController.updateFollowing(following, status: Following.Status.accepted)
    }
    
    func declineButtonPressed(sender: PendingRequestCell) {
        guard let indexPath = tableView.indexPathForCell(sender), queryResults = queryResults else { return }
        let record = queryResults[indexPath.row]
        guard let following = Following(cloudKitRecord: record) else { return }
        FollowingController.sharedController.updateFollowing(following, status: Following.Status.denied)
    }
}
