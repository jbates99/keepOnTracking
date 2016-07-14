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
    
    let container = CKContainer.defaultContainer()
    
    func requestAccess() {
        container.requestApplicationPermission(.UserDiscoverability) { (permissionStatus, error) in
            if error != nil {
                print("Error: \(error)")
            }
        }
        
    }
    
   func discoverUsers(completion: (users: [CKDiscoveredUserInfo]) -> Void) {
        let container = self.container
        var discoveredUsers: [CKDiscoveredUserInfo] = []
        container.discoverAllContactUserInfosWithCompletionHandler { (users, error) in
            if error != nil {
                print("Error: \(error)")
                discoveredUsers = []
            } else if users != nil {
                guard let users = users else { return }
                discoveredUsers = users
            }
        }
        completion(users: discoveredUsers)
        Dispatch.main.async {
        }
        
    }

    
}
