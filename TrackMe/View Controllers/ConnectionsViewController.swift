//
//  ConnectionsViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/21/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

class ConnectionsViewController: UITableViewController {
    
    var connections = [Connections]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUpDataSource), name: "currentUserSet", object: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = connections.count
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
        
        cell.setUpCell(with: connections[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func setUpDataSource() {
        guard let currentID = FollowingController.sharedController.currentUserRecordID else { return }
        ConnectionsController.sharedController.setUpConnections(currentID) { (connections) in
            if let connections = connections {
                self.connections = connections
                Dispatch.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ConnectionsViewController: ConnectionTableViewCellDelegate {
    func notifyMeButtonPressed(sender: ConnectionTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(sender) else { return }
        let connection = connections[indexPath.row]
        if connection.notified == false {
            MessageController.sharedController.subscribeForPushNotifications(connection.userID)
        } else {
            MessageController.sharedController.unsubscribeForPushNotifications(connection.userID)
        }
        tableView.reloadData()
    }
}
