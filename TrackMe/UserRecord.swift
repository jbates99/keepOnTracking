//
//  UserRecord.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

struct User {
    var requestedToFollow: [CKReference] = []
    var following: [CKReference] = []
    var followerRequests: [CKReference] = []
    var followers: [CKReference] = []

}