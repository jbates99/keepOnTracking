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
    
    static let container = CKContainer.defaultContainer()
    
    static func requestAccess() {
        container.requestApplicationPermission(.UserDiscoverability) { (permissionStatus, error) in
            if error != nil {
                print("Error: \(error)")
            }
        }
        
    }
    
}
