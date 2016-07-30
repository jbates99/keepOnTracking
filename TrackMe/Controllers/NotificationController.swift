//
//  NotificationController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class NotificationController {
    
    static let sharedInstance = NotificationController()
    
    let cloudKitManager = CloudKitManager()
    
    var discoveredRecords = [CKDiscoveredUserInfo]() {
        didSet {
            usersDict = [String: CKDiscoveredUserInfo]()
            for record in discoveredRecords {
                guard let recordName = record.userRecordID?.recordName else { break }
                usersDict[recordName] = record
            }
        }
    }
    
    var usersDict = [String: CKDiscoveredUserInfo]()
    
    func requestAccess() {
        cloudKitManager.requestDiscoverabilityPermission()
    }
    
    func discoverUsers(completion: ((success: Bool) -> Void)?) {
        cloudKitManager.fetchAllDiscoverableUsers { users in
            if let users = users {
                self.discoveredRecords = users
                completion?(success: true)
            }
        }
    }
    
    func followingUserInfo(for userRecord: CKRecord) -> CKDiscoveredUserInfo? {
        if let recordID = userRecord.lastModifiedUserRecordID {
            let recordName = recordID.recordName
            return usersDict[recordName]
        } else {
            print("Unable to access modifier recordID")
            return nil
        }
    }
    
    func creatorUserInfo(for userRecord: CKRecord) -> CKDiscoveredUserInfo? {
        if let recordID = userRecord.lastModifiedUserRecordID {
            let recordName = recordID.recordName
            return usersDict[recordName]
        } else {
            print("Unable to access creator recordID")
            return nil
        }
    }
    
    
}
