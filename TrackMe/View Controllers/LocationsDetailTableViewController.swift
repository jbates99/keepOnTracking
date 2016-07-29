//
//  LocationsDetailTableViewController.swift
//  Capstone
//
//  Created by Joshua Bates on 7/6/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsDetailTableViewController: UITableViewController {
    
    var regions = [CLRegion]()
     
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpRegions()
    }
    
    // MARK: - Table view delegate functions
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = regions.count
        if count == 0 {
            tableView.emptyMessage("You currently have no locations. Press the add button to add your first!", viewController: self)
            return 0
        } else if count >= 1 {
            tableView.removeMessage(self)
            return count
        } else {
            return count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! ButtonTableViewCell
        
        let region = regions[indexPath.row]
        cell.updateWithLocation(region)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let region = regions[indexPath.row]
            
            let manager = LocationManagerController.sharedInstance.manager
            manager.stopMonitoringForRegion(region)
            LocationManagerController.sharedInstance.setUpRegions()
            
        } else {
            print("Unable to access the manager")
        }
        regions.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let detailViewController = segue.destinationViewController as? NewLocationViewController else { fatalError("unexpected destination from segue") }
        if segue.identifier == "savedLocation" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                guard let region = regions[selectedIndexPath.row] as? CLCircularRegion else { return }
                detailViewController.region = region
            }
        }
    }
    
    // MARK: - Private functions
    
    private func setUpRegions() {
        let sharedInstance = LocationManagerController.sharedInstance
        sharedInstance.setUpRegions()
        let discoveredRegions = sharedInstance.regions
        regions = discoveredRegions
        self.tableView.reloadData()
    }
    
}

    // MARK: - Button Cell Delegate

extension LocationsDetailTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        
    }
}


