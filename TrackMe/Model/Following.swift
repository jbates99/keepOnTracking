//
//  Following.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/14/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

struct Following {
    
    let sentTo: CKReference
    var status: Int
    
}

extension Following {
    static var sentToKey: String { return "SentTo" }
    static var statusKey: String { return "Status" }
    static var recordType: String { return "Following" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let sentTo = cloudKitRecord[Following.sentToKey] as? CKReference,
            status = cloudKitRecord[Following.statusKey] as? Int
            where cloudKitRecord.recordType == Following.recordType else { return nil }
        
        self.init(sentTo: sentTo, status: status)
    }
    
    init(recordID: CKRecordID, status: Following.Status = .pending) {
        let reference = CKReference(recordID: recordID, action: .None)
        self.sentTo = reference
        self.status = status.rawValue
    }
}

extension CKRecord {
    convenience init(following: Following) {
        self.init(recordType: Following.recordType)
        self[Following.sentToKey] = following.sentTo
        self[Following.statusKey] = following.status
        
    }
}


extension Following {
    enum Status: Int {
        case pending
        case accepted
        case denied
    }
}
