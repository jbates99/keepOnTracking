//
//  RegionController.swift
//  Capstone
//
//  Created by Joshua Bates on 7/5/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CloudKit

class RegionController {
    
    static let sharedController = RegionController()
    
    var geoFences = [GeoFence]()
    
    static func createRegion(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, name: String, status: Bool = true) {
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: name)
        let geofence = GeoFence.init(region: region, status: status, name: name)
        
        // MARK: Creates Record
        let record = CKRecord(geoFence: geofence)
        let db = CKContainer.defaultContainer().privateCloudDatabase
        db.saveRecord(record) { (record, error) in
            if let error = error {
                print("Error saving \(geofence) to CloudKit: \(error)")
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.sharedController.geoFences.append(geofence)
            }
        
        }
        
        // MARK: Starts Monitoring Region
        if let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager {
            manager.startMonitoringForRegion(region)
        } else {
            print("Unable to access the manager")
        }
    }
    
    static func statusToggled(geoFence: GeoFence) {
        if geoFence.status == false {
            // geoFence.status = true
            if let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager {
                manager.startMonitoringForRegion(geoFence.region)
            } else {
                print("Unable to access the manager")
            }
        } else {
            // geoFence.status = false
            if let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager {
                manager.stopMonitoringForRegion(geoFence.region)
            } else {
                print("Unable to access the manager")
            }
        }
        
    }
    
}
