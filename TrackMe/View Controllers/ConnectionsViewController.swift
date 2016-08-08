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
    
    
    var connections: [Connections]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        HUD.show(.Progress)
        HUD.dimsBackground = false
        HUD.allowsInteraction = true
        setUpDataSource()
        tableView.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(retrieveConnections), name: "connectionsSet", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUpDataSource), name: "usersDictSet", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        HUD.hide()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = connections?.count ?? 0
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
        guard let connections = connections else { return UITableViewCell() }
        cell.setUpCell(with: connections[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func setUpDataSource() {
        guard let currentID = FollowingController.sharedController.currentUserRecordID else { return }
        ConnectionsController.sharedController.setUpConnections(currentID) { (connections) in
            self.connections = connections
        }
    }
    
    func retrieveConnections() {
        connections = ConnectionsController.sharedController.connections
        Dispatch.main.async {
            self.tableView.reloadData()
            HUD.hide()
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "messageUpdates" {
        guard let detailViewController = segue.destinationViewController as? UserMessageTableViewController else { fatalError("unexpected destination from segue") }
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                guard let connections = connections else { return }
                let connection = connections[selectedIndexPath.row]
                detailViewController.connection = connection
            }
        }
    }
    
}

extension ConnectionsViewController: ConnectionTableViewCellDelegate {
    func notifyMeButtonPressed(sender: ConnectionTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(sender), connections = connections else { return }
        let connection = connections[indexPath.row]
        if connection.notified == false {
            MessageController.sharedController.subscribeForPushNotifications(connection.userID)
        } else {
            MessageController.sharedController.unsubscribeForPushNotifications(connection.userID)
        }
        tableView.reloadData()
    }
}
