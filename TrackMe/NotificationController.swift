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
    
    var discoveredRecords = [CKDiscoveredUserInfo]()
    
    let container = CKContainer.defaultContainer()
    
    func requestAccess() {
        container.requestApplicationPermission(.UserDiscoverability) { permissionStatus, error in
            if error != nil {
                print("Error: \(error)")
            } else if permissionStatus == CKApplicationPermissionStatus.Granted {
                
            }
        }
    }
    
    func discoverUsers(completion: (success: Bool) -> Void) {
        container.discoverAllContactUserInfosWithCompletionHandler { users, error in
            if let error = error {
                print("Error: \(error)")
                completion(success: false)
            } else {
                guard let users = users else { return }
                self.discoveredRecords = users
                completion(success: true)
            }
        }
    }
    
}
