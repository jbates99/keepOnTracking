//
//  MessageController.swift
//  CloudKitPractice
//
//  Created by Joshua Bates on 6/18/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

let MessageControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class MessageController {
    static let sharedController = MessageController()
    
    var currentUserName: String?
    
    func getCurrentUserName() {
        let db = CKContainer.defaultContainer()
        db.fetchUserRecordIDWithCompletionHandler { recordID, error in
            if let error = error {
                print("\(error)")
            } else if let recordID = recordID {
                db.discoverUserInfoWithUserRecordID(recordID) { discoveredInfo, error in
                    if let error = error {
                        print("\(error)")
                    } else if let discoveredInfo = discoveredInfo {
                        guard let contact = discoveredInfo.displayContact else { return }
                        let username = "\(contact.givenName) \(contact.familyName)"
                        self.currentUserName = username
                    }
                }
            }
        }
    }
    
    init() {
        refresh()
    }
    
    func postNewMessage(message: Message) {
        let record = CKRecord(message: message)
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.saveRecord(record) { record, error in
            if let error = error {
                NSLog("Error saving \(message) to CloudKit: \(error)")
                return
            }
            Dispatch.main.async {
                self.messages.append(message)
            }
            self.refresh()
        }
    }
    
    func fetchMessagesForUser(recordID recordID: CKRecordID, completion: (messages: [Message]?) -> Void) {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        let createdByReference = CKReference(recordID: recordID, action: .None)
        let query = CKQuery(recordType: Message.recordType, predicate: NSPredicate(format: "creatorUserRecordID == %@", argumentArray: [createdByReference]))
        query.sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: true)]
        db.performQuery(query, inZoneWithID: nil) { records, error in
            if let error = error {
                AlertController.displayError(error, withMessage: nil)
                completion(messages: nil)
            } else {
                guard let records = records?.suffix(40) else { completion(messages: nil); return }
                let messages = records.flatMap { Message(cloudKitRecord: $0) }
                completion(messages: messages)
            }
        }
    }
    
    func fetchLatestUserUpdateMessage(recordID: CKRecordID, completion: (message: Message?) -> Void) {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        let createdByReference = CKReference(recordID: recordID, action: .None)
        let query = CKQuery(recordType: Message.recordType, predicate: NSPredicate(format: "creatorUserRecordID == %@", argumentArray: [createdByReference]))
        query.sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: false)]
        
        db.performQuery(query, inZoneWithID: nil) { records, error in
            
            if let error = error {
                NSLog("Error \(error) when fetching data")
                completion(message: nil)
            } else {
                guard let records = records?.suffix(1) else { completion(message: nil); return }
                let messages = records.flatMap { Message(cloudKitRecord: $0) }
                completion(message: messages.first)
            }
        }
    }
    
    func refresh() {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        
        let query = CKQuery(recordType: Message.recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: true)]
        
        db.performQuery(query, inZoneWithID: nil) { records, error in
            if let error = error {
                NSLog("Error fetching from cloudKit: \(error)")
                return
            }
            guard let records = records?.suffix(20) else { return }
            let messages = records.flatMap { Message(cloudKitRecord: $0) }
            Dispatch.main.async {
                self.messages = messages
            }
        }
    }
    
    private(set) var messages = [Message]() {
        didSet {
            let nc = NSNotificationCenter.defaultCenter()
            nc.postNotificationName(MessageControllerDidRefreshNotification, object: self)
        }
    }
    
    func subscribeForPushNotifications(userID: CKRecordID) {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.fetchAllSubscriptionsWithCompletionHandler { (subscriptions, error) in
            if let error = error {
                NSLog("Error fetching subscriptions: \(error)")
                return
            }
            if let subscriptions = subscriptions where subscriptions.count > 0 {
                NSLog("Already subscribed")
                return
            }
            
//            let createdByReference = CKReference(recordID: userID, action: .None)
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", argumentArray: [userID])
            
            let subscription = CKSubscription(recordType: Message.recordType, predicate: predicate, options: .FiresOnRecordCreation)
            let notificationInfo = CKNotificationInfo()
            
            notificationInfo.alertBody = "A user has updated their location."
            
            subscription.notificationInfo = notificationInfo
            db.saveSubscription(subscription) { (subscription, error) in
                if let error = error {
                    NSLog("Error saving subscription: \(error)")
                    return
                } else {
                    print(subscription)
                }
            }
        }
    }
    
    func notifyMe() {
        
    }
    
    func unsubscribeForPushNotifications(userID: CKRecordID) {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.fetchAllSubscriptionsWithCompletionHandler { subscriptions, error in
            if let error = error {
                AlertController.displayError(error, withMessage: nil)
                return
                // FIXME: set up unsubscribe function
                //            } else if let subscriptions = subscriptions {
                //                let predicate = NSPredicate(format: "UserID CONTAINS %@", argumentArray: [userID])
                //                let subscription = subscriptions.indexOf
            }
        }
    }
    
}
