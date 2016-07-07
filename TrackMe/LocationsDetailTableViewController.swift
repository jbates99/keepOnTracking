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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRegions()
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
        
        return regions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! ButtonTableViewCell
        
        let region = regions[indexPath.row]
        cell.updateWithLocation(region)
        cell.delegate = self

        return cell
    }
    
    func setUpRegions() {
        if let regions = (UIApplication.sharedApplication().delegate as? AppDelegate)?.regions {
            self.regions = regions
        } else {
            self.regions = []
        }
        self.tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let region = regions[indexPath.row]
            if let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager {
                manager.stopMonitoringForRegion(region)
            } else {
                print("Unable to access the manager")
            }
            setUpRegions()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationsDetailTableViewController: ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        if let indexPath = tableView.indexPathForCell(sender) {
            let location = RegionController.sharedController.geoFences[indexPath.row]
            RegionController.statusToggled(location)
            tableView.reloadData()
        }
    }
}
