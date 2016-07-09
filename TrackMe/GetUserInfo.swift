//
//  GetUserInfo.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/9/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class GetUserInfo {
    
    static let sharedInstance = GetUserInfo()
    
    var userRecordID: CKRecordID?
    var currentUserProfile: CKRecord?
    
    private init() { }
    
    typealias Block = () -> Void
    var downloadGroup = dispatch_group_create()
    
    func getUserID(completion: Block) {
        dispatch_group_enter(downloadGroup)
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (recordID, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print(recordID)
                self.userRecordID = recordID
                self.getUserProfile()
            }
        }
        
        dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    func getUserProfile() {
        guard let userRecordID = userRecordID else { return }
        let ref = CKReference(recordID: userRecordID, action: .None)
        
        let predicate = NSPredicate(format: "creatorUserRecordID == %@", ref)
        let query = CKQuery(recordType: "Profile", predicate: predicate)
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(query, inZoneWithID: nil) {
            records, error in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                self.currentUserProfile = records?.first
                dispatch_group_leave(self.downloadGroup)
            }
        }
    }
    
}
