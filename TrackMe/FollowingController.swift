//
//  FollowingController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/14/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class FollowingController {
    
    static let sharedController = FollowingController()
    
    
    let cloudKitManager = CloudKitManager()
    
    func createReference(recordID: CKRecordID) -> CKReference {
        return CKReference(recordID: recordID, action: .None)
    }
    
    func createFollowing(sentTo: CKReference) {
        let following = Following(sentTo: sentTo, date: NSDate(), status: 0)
        let record = CKRecord(following: following)
        cloudKitManager.saveRecord(record) { record, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func retrieveFollowings() -> [CKRecord]? {
        var retrievedRecords = [CKRecord]?()
        cloudKitManager.fetchCurrentUserRecords("Following") { records, error in
            if let records = records {
                retrievedRecords = records
            } else if let error = error {
                print("Error: \(error)")
                retrievedRecords = nil
            }
        }
        return retrievedRecords
    }
    
    func updateFollowing() {
        
    }
    
    func deleteFollowing(recordID: CKRecordID) {
        cloudKitManager.deleteRecordWithID(recordID) { recordID, error in
            if let recordID = recordID {
                print("Record with ID: \(recordID) successfully deleted")
            } else if let error = error {
                print("Error: \(error) when deleting record")
            }
        }
    }
}
