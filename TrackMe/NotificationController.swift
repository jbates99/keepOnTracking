//
//  NotificationController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/7/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class NotificationController {
    
    let container = CKContainer.defaultContainer()

//    func userForEmailAddress(email: String, completion: (id: CKRecordID?) -> CKRecordID?) {
//        var id: CKRecordID?
//        container.discoverUserInfoWithEmailAddress(email, completionHandler: { (response, error) in
//            if error != nil {
//                print("Error retrieving user for email: \(error)")
//                id = nil
//            } else {
//                guard let response = response else { return }
//                id = response.userRecordID
//            }
//        })
//        return id
//    }
   
    func requestFollow(id: CKRecordID) {
        
    }
    
    func acceptFollow() {
        
    }
    
    func denyFollow() {
        
    }
    
    
    
}
