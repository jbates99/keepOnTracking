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
    
    var currentUserRecordID: CKRecordID?
    
    let cloudKitManager = CloudKitManager()

    func createFollowing(recordID: CKRecordID) {
        let following = Following(recordID: recordID)
        let record = CKRecord(following: following)
        cloudKitManager.saveRecord(record) { record, error in
            if let error = error {
                print("Error: \(error)")
            } else if record != nil {
                print("Record saved")
            }
        }
    }
    
    func retrieveFollowingRequests(by recordID: CKRecordID, completion: (returnedRecords: [CKRecord]?) -> Void) {
        let reference = CKReference(recordID: recordID, action: .None)
        let predicate = NSPredicate(format: "SentTo == %@", argumentArray: [reference])
        cloudKitManager.fetchRecordsWithType("Following", predicate: predicate, recordFetchedBlock: nil) { records, error in
            if let error = error {
                AlertController.displayError(error, withMessage: nil)
                completion(returnedRecords: nil)
            } else if let records = records {
                completion(returnedRecords: records)
            }
        }
    }
    
    func retrieveFollowingsForCurrentUser(completion: (followings: [Following]?) -> Void) {
        cloudKitManager.fetchCurrentUserRecords("Following") { records, error in
            guard let records = records else { return }
            var followings = [Following]()
            for record in records {
                guard let following = Following(cloudKitRecord: record) else { break }
                followings.append(following)
            }
            completion (followings: followings)
        }
    }
    
    func retrieveFollowingsRequestsByStatus(status: Int, recordID: CKRecordID, completion: (returnedRecords: [CKRecord]?) -> Void) {
        let reference = CKReference(recordID: recordID, action: .None)
        let predicate = NSPredicate(format: "SentTo == %@ AND Status == \(status)", argumentArray: [reference])
        cloudKitManager.fetchRecordsWithType("Following", predicate: predicate, recordFetchedBlock: { record in
        }) { (records, error) in
            if let error = error {
                AlertController.displayError(error, withMessage: nil)
                completion(returnedRecords: nil)
            } else if let records = records {
                completion(returnedRecords: records)
            }
        }
    }
    
    func updateFollowing(following: Following, status: Following.Status) {
        var followingCopy = following
        followingCopy.status = status.rawValue
        let record = CKRecord(following: following)
        cloudKitManager.modifyRecords([record], perRecordCompletion: { (record, error) in
            if let error = error {
                print(error)
            }
        }) { (records, error) in
            if let error = error {
                print(error)
            }
        }
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
