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
    
    let sentBy: CKReference
    let sentTo: CKReference
    let date: NSDate
    var status: Int
    
}

extension Following {
    static var dateKey: String { return "Date" }
    static var sentByKey: String { return "SentBy" }
    static var sentToKey: String { return "SentTo" }
    static var statusKey: String { return "Status" }
    static var recordType: String { return "Following" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let sentBy = cloudKitRecord[Following.sentByKey] as? CKReference,
            sentTo = cloudKitRecord[Following.sentToKey] as? CKReference,
            date = cloudKitRecord[Following.dateKey] as? NSDate,
            status = cloudKitRecord[Following.statusKey] as? Int
            where cloudKitRecord.recordType == Following.recordType else { return nil }
        
        self.init(sentBy: sentBy, sentTo: sentTo, date: date, status: status)
    }
}

extension CKRecord {
    convenience init(following: Following) {
        self.init(recordType: Following.recordType)
        self[Following.sentToKey] = following.sentTo
        self[Following.sentByKey] = following.sentBy
        self[Following.dateKey] = following.date
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
