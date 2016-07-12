//
//  UserController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/9/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let sharedInstance = UserController()
    static let container = CKContainer.defaultContainer()
    var currentUser: User?
    
    static func fetchCurrentUserID(completion: (userID: CKRecordID?, error: NSError?) -> Void) {
        container.fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(userID: nil, error: error)
            } else {
                print("fetched ID\(recordID?.recordName)")
                completion(userID: recordID, error: nil)
            }
        }
    }
    
    static func createUser(name: String, userID: String, child: Bool = true, requestedToFollow: [CKReference] = [], following: [CKReference] = [], followerRequests: [CKReference] = [], followers: [CKReference] = [], completion: (success: Bool, user: User?) -> Void) {
        fetchCurrentUserID { (userID, error) in
            if let userID = userID where error == nil {
                let userAsString = String(userID)
                let user = User(name: name, userID: userAsString, requestedToFollow: requestedToFollow, following: following, followerRequests: followerRequests, followers: followers)
                completion(success: true, user: user)
                self.sharedInstance.currentUser = user
            } else {
                print(error)
                completion(success: false, user: nil)
            }
        }
    }
    
    
    
}
