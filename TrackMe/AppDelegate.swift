//
//  AppDelegate.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/6/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit

import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var regions = [CLRegion]()
    let manager = CLLocationManager()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // MARK: Local Notification Permissions
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // MARK: Remote Notification Permissions
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        // MARK: - Set Up Location Manager
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone  // Whenever user moves
        manager.desiredAccuracy = kCLLocationAccuracyBest // Best Accuracy
        
        // MARK: - Location Permissions
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
            manager.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            manager.startUpdatingLocation()
        }
        
        setUpRegions()
        
        return true
    }
    
    func setUpRegions() {
        regions = Array(manager.monitoredRegions)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion")
        let localNotification = UILocalNotification()
        localNotification.alertBody = "User has left \(region.identifier)"
        localNotification.alertTitle = "Location Alert"
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didExitRegion")
        let localNotification = UILocalNotification()
        localNotification.alertBody = "User has entered \(region.identifier)"
        localNotification.alertTitle = "Location Alert"
        localNotification.fireDate = NSDate()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    // MARK: - Location Authorization Changed
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

