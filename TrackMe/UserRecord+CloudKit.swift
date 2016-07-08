//
//  UserRecord+CloudKit.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

//
//import Foundation
//import CloudKit
//
//extension UserRecord {
//    static var requestedToFollowKey: String { return "requested" }
//    static var followingKey: String { return "following" }
//    static var followerRequestsKey: String { return "requests" }
//    static var followersKey: String { return "followers" }
//   
//    init?(cloudKitRecord: CKRecord) {
//        guard let requestedToFollow = cloudKitRecord[UserRecord.requestedToFollowKey] as? [CKReference : Bool],
//        following = cloudKitRecord[UserRecord.followingKey] as? [CKReference : Bool],
//        followerRequests = cloudKitRecord[UserRecord.followerRequestsKey] as? [CKReference : Bool],
//        followers = cloudKitRecord[UserRecord.followersKey] as? [CKReference : Bool]
//        where cloudKitRecord.recordType == UserRecord.recordType else { return nil }
//        
//        self.init(requestedToFollow: requestedToFollow, following: following, followerRequests: followerRequests, followers : followers)
//    }
//}
//
//extension CKRecord {
//    convenience init(userRecord: UserRecord) {
//        self.init(recordType: UserRecord.recordType)
//        self[UserRecord.requestedToFollowKey] = UserRecord.requestedToFollow
//        self[UserRecord.followingKey] = UserRecord.followingKey
//        self[UserRecord.followerRequestsKey] = UserRecord.followerRequests
//        self[UserRecord.followersKey] = UserRecord.followers
//    }
//}
