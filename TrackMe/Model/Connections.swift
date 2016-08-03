//
//  Connections.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/26/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit
import CoreLocation

class Connections {
    
    let name: String
    let message: String?
    let userID: CKRecordID
    var notified: Bool
    
    init(name: String, message: String?, userID: CKRecordID, notified: Bool = false) {
        self.name = name
        self.message = message
        self.userID = userID
        self.notified = notified
    }
    
}