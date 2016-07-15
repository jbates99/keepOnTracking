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
    
    let cloudKitManager = CloudKitManager()
    
    var discoveredRecords = [CKDiscoveredUserInfo]()
    
    func requestAccess() {
        cloudKitManager.requestDiscoverabilityPermission()
    }
    
    func discoverUsers(completion: (success: Bool) -> Void) {
        cloudKitManager.fetchAllDiscoverableUsers { users in
            if let users = users {
                self.discoveredRecords = users
                completion(success: true)
            }
        }
    }
    
}
