//
//  UserRecord.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CloudKit

struct User {
    
    var name: String
    let userID: String
    let child: Bool = true
    
    var following: [String] = []

}