//
//  ConnectionsController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/26/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.


import Foundation
import CloudKit
import CoreLocation

class ConnectionsController {
    
    static let sharedController = ConnectionsController()
    
    var queryResults: [CKRecord]?
    var messagesResults = [Message]()
    
    var filteredResults: [CKRecord]? {
        guard let queryResults = queryResults else { return nil }
        return queryResults.filter { $0.creatorUserRecordID?.recordName == "__defaultOwner__" }
    }
    
    func createMessage() {
        
    }
    
    func setUpConnections(currentUserID: CKRecordID, completion: (connections: [Connections]?) -> Void) {
        
    }
    
}
