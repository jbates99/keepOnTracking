//
//  UserRecord+CloudKit.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//


import UIKit
import CloudKit

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
        guard let requestedToFollow = cloudKitRecord[User.requestedToFollowKey] as? [CKReference],
        following = cloudKitRecord[User.followingKey] as? [CKReference],
        followerRequests = cloudKitRecord[User.followerRequestsKey] as? [CKReference],
        followers = cloudKitRecord[User.followersKey] as? [CKReference],
        name = cloudKitRecord[User.nameKey] as? String,
        userID = cloudKitRecord[User.userIDKey] as? String
        where cloudKitRecord.recordType == User.recordType else { return nil }
        
        self.init(name: name, userID: userID, requestedToFollow: requestedToFollow, following: following, followerRequests: followerRequests, followers : followers)
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: User.recordType)
        self[User.childKey] = user.child
        self[User.userIDKey] = user.userID
        self[User.requestedToFollowKey] = user.requestedToFollow
        self[User.followingKey] = user.following
        self[User.followerRequestsKey] = user.followerRequests
        self[User.followersKey] = user.followers
        self[User.nameKey] = user.name
    }
}
