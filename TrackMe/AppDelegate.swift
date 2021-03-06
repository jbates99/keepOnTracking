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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let managerInstance = LocationManagerController.sharedInstance
        
        managerInstance.setUpRegions()
        setUpUsers()
        setUpNotifications()
        storeUserRecordID()
        AppearanceController.initializeAppearance()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setUpUsers), name: "currentUserSet", object: nil)
        
        return true
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

// MARK: - User Set Up

extension AppDelegate {
    
    func setUpCurrentUser() {
        MessageController.sharedController.getCurrentUserName()
    }
    
    func storeUserRecordID() {
        let followingController = FollowingController.sharedController
        followingController.cloudKitManager.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { return }
            followingController.currentUserRecordID = record.recordID
            NSNotificationCenter.defaultCenter().postNotificationName("currentUserSet", object: nil)
        }
    }
    
    func setUpUsers() {
        NotificationController.sharedInstance.discoverUsers { (success) in
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName("usersDictSet", object: nil)
            }
        }
    }
    
}

// MARK: - Notification Handling

extension AppDelegate {
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func setUpNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
}

