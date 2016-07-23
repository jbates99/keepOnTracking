//
//  FamilyMembersTableViewController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/21/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit

class FamilyMembersTableViewController: UITableViewController {
    
    @IBOutlet weak var hiddenView: UIView!
    var followings = [Following]()
    
    var acceptedFollowings: [Following] {
        return followings.filter { $0.status == 1 }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = acceptedFollowings.count
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

    func setUpDataSource() {
        FollowingController.sharedController.retrieveFollowingsForCurrentUser { (followings) in
            
        }
    }

}
