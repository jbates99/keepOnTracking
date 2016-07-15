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
    
    var following = [String]()
    
    init(name: String, userID: String, following: [String] = [String]()) {
        self.name = name
        self.userID = userID
        self.following = following
    }

}

extension User {
    static var requestedToFollowKey: String { return "requested" }
    static var followingKey: String { return "following" }
    static var followerRequestsKey: String { return "requests" }
    static var followersKey: String { return "followers" }
    static var nameKey: String { return "name" }
    static var userIDKey: String { return "userID" }
    static var childKey: String { return "child" }
    static var recordType: String { return "User" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let following = cloudKitRecord[User.followingKey] as? [String],
            name = cloudKitRecord[User.nameKey] as? String,
            userID = cloudKitRecord[User.userIDKey] as? String
            where cloudKitRecord.recordType == User.recordType else { return nil }
        
        self.init(name: name, userID: userID, following: following)
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: User.recordType)
        self[User.childKey] = user.child
        self[User.userIDKey] = user.userID
        self[User.followingKey] = user.following
        self[User.nameKey] = user.name
    }
}
