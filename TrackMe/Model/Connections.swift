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
    let message: String
    let region: CLRegion
    
    init(name: String, message: String, region: CLRegion) {
        self.name = name
        self.message = message
        self.region = region
    }
    
}