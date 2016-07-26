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
    
    @IBOutlet weak var hiddenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRegions()
        hiddenView.backgroundColor = AppearanceController.offWhite
        tableView.tableHeaderView = hiddenView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        setUpRegions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = regions.count
        if count == 0 {
            tableView.tableHeaderView?.hidden = false
            return count
        } else if count >= 1 {
            tableView.tableHeaderView?.hidden = true
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
    
    func setUpRegions() {
        guard let delegate = (UIApplication.sharedApplication().delegate as? AppDelegate) else { return }
        delegate.setUpRegions()
        if let regions = (UIApplication.sharedApplication().delegate as? AppDelegate)?.regions {
            self.regions = regions
        } else {
            self.regions = []
        }
        self.tableView.reloadData()
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let region = regions[indexPath.row]
            guard let delegate = (UIApplication.sharedApplication().delegate as? AppDelegate) else { return }
            let manager = delegate.manager
            manager.stopMonitoringForRegion(region)
            delegate.setUpRegions()
            
        } else {
            print("Unable to access the manager")
        }
        regions.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let detailViewController = segue.destinationViewController as? NewLocationViewController else { fatalError("unexpected destination from segue") }
        if segue.identifier == "savedLocation" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                guard let region = regions[selectedIndexPath.row] as? CLCircularRegion else { return }
                detailViewController.region = region
            }
        }
    }
    
    
}

extension LocationsDetailTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        
    }
}
