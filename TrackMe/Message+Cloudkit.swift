//
//  Message+Cloudkit.swift
//  CloudKit
//
//  Created by Joshua Bates on 6/18/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

extension Message {
    static var dateKey: String { return "Date" }
    static var messageTextKey: String { return "MessageText" }
    static var recordType: String { return "Message" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let messageText = cloudKitRecord[Message.messageTextKey] as? String,
        date = cloudKitRecord["Date"] as? NSDate
            where cloudKitRecord.recordType == Message.recordType else { return nil }
        
        self.init(messageText: messageText, date: date)
    }
}

extension CKRecord {
    convenience init(message: Message) {
        self.init(recordType: Message.recordType)
        self[Message.messageTextKey] = message.messageText
        self[Message.dateKey] = message.date
    }
}
