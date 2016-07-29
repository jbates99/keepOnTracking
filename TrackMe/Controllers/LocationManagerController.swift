//
//  LocationManagerController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/28/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerController: NSObject {
    
    static let sharedInstance = LocationManagerController()
    
    let manager = CLLocationManager()
    var regions = [CLRegion]()
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone  // Whenever user moves
        manager.desiredAccuracy = kCLLocationAccuracyBest // Best Accuracy
    }
    
    func setUpRegions() {
        regions = Array(manager.monitoredRegions)
    }
    

    
}

// MARK: - Location Manager Delegate Functions

extension LocationManagerController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "User has left \(region.identifier)"
        localNotification.alertTitle = "Location Alert"
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        guard let username = MessageController.sharedController.currentUserName, userID = FollowingController.sharedController.currentUserRecordID else { return }
        let IDAsString = String(userID)
        MessageController.sharedController.postNewMessage(Message(messageText: "User \(username) has left \(region.identifier)", date: NSDate(), userID: IDAsString))
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "User has entered \(region.identifier)"
        localNotification.alertTitle = "Location Alert"
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        guard let username = MessageController.sharedController.currentUserName, userID = FollowingController.sharedController.currentUserRecordID else { return }
        let IDAsString = String(userID)
        MessageController.sharedController.postNewMessage(Message(messageText: "User \(username) has entered \(region.identifier)", date: NSDate(), userID: IDAsString))
    }
    
    // MARK: - Location Authorization Changed
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
}
