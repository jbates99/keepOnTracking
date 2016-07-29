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
    let message: Message
    let userID: String
    
    init(name: String, message: Message, region: String, userID: String) {
        self.name = name
        self.message = message
        self.userID = userID
    }
    
}