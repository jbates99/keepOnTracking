//
//  MessageController.swift
//  CloudKitPractice
//
//  Created by Joshua Bates on 6/18/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

let MessageControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class MessageController {
    static let sharedController = MessageController()
    
    init() {
        refresh()
    }
    
    func postNewMessage(message: Message) {
        let record = CKRecord(message: message)
        let db = CKContainer.defaultContainer().publicCloudDatabase
        db.saveRecord(record) { (record, error) in
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
    
    func refresh() {
        let db = CKContainer.defaultContainer().publicCloudDatabase
        
        let query = CKQuery(recordType: Message.recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: true)]
        
        db.performQuery(query, inZoneWithID: nil) { (records, error) in
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
    
    static func subscribeForPushNotifications(userID: String) {
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
            
            let subscription = CKSubscription(recordType: Message.recordType, predicate: NSPredicate(format: "userID CONTAINS '\(userID)'"), options: .FiresOnRecordCreation)
            let notificationInfo = CKNotificationInfo()
            notificationInfo.alertBody = "A user has updated their location."
            subscription.notificationInfo = notificationInfo
            db.saveSubscription(subscription) { (subscription, error) in
                if let error = error {
                    NSLog("Error saving subscription: \(error)")
                    return
                }
            }
        }
    }
    
}