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
    static let db = CKContainer.defaultContainer().publicCloudDatabase
    
    static var currentUser: User?
    
    static func fetchCurrentUser(with recordID: CKRecordID) {
        db.fetchRecordWithID(recordID) { record, error in
            if let record = record {
                guard let user = User(cloudKitRecord: record) else { return }
                currentUser = user
            } else if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    static func loadCurrentUser() {
        fetchCurrentUserID { userID, error in
            if let userID = userID {
                fetchCurrentUser(with: userID)
            }
        }
    }
    
    static func fetchCurrentUserID(completion: (userID: CKRecordID?, error: NSError?) -> Void) {
        container.fetchUserRecordIDWithCompletionHandler { recordID, error in
            if let recordID = recordID {
                print("fetched ID\(recordID.recordName)")
                completion(userID: recordID, error: nil)
                } else if let error = error {
                    print("Error: \(error)")
                }
            }
        }
        
        static func createUser(name: String, child: Bool = true, following: [String], completion: (success: Bool, user: User?) -> Void) {
            fetchCurrentUserID { userID, error in
                if let userID = userID where error == nil {
                    let userAsString = String(userID)
                    let following = [userAsString]
                    let user = User(name: name, userID: userAsString, following: following)
                    let record = CKRecord(user: user)
                    db.saveRecord(record, completionHandler: { record, error in
                        // error check
                        completion(success: true, user: user)
                    })
                } else {
                    print(error)
                    completion(success: false, user: nil)
                }
            }
        }
        
}
