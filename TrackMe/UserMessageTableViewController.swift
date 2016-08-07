//
//  UserMessageTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 8/6/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit

class UserMessageTableViewController: UITableViewController {
    
    var connection: Connections?
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDataSource()
        tableView.reloadData()
        guard let connection = connection else { return }
        self.title = connection.name
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messages = messages else { return 0 }
        return messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        guard let messages = messages else { return UITableViewCell() }
        let message = messages[indexPath.row]
        
        cell.textLabel?.text = "\(message.messageText) at \(message.date.stringValue())"
        
        return cell
    }
    
    func setUpDataSource() {
        if let connection = connection {
            MessageController.sharedController.fetchMessagesForUser(recordID: connection.userID) { messages in
                guard let messages = messages else { self.messages = []; return }
                self.messages = messages
                Dispatch.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            messages = []
        }
    }
    
}
