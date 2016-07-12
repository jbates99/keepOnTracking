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
    
    var name: String = ""
    
    static var requestedToFollow: [CKReference] = []
    static var following: [CKReference] = []
    static var followerRequests: [CKReference] = []
    static var followers: [CKReference] = []

}