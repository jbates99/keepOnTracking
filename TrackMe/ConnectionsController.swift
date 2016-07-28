//
//  ConnectionsController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/26/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//
//
//import Foundation
//import CloudKit
//import CoreLocation
//
//class ConnectionsController {
//    
//    let connectionGroup = dispatch_group_create()
//    
//    func createConnection(record: CKRecord) {
//        var userInfo: CKDiscoveredUserInfo
//        var recordID: CKRecordID {
//            return record.recordID
//        }
//        var name: String
//        var modifierID: CKRecordID
//        var location: CLRegion
//        var setMessage: Message?
//        
//        dispatch_group_enter(connectionGroup)
//        MessageController.sharedController.fetchLatestUserUpdateMessage(recordID) { (message) in
//            guard let messages = message else { return }
//            let newMessage = messages[1]
//            setMessage = newMessage
//        }
//        guard let message = setMessage else { return }
//     let connection = Connections(name: name, message: message.messageText, region: <#T##CLRegion#>)
//    }
//    
//    
//}
