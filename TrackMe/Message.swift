//
//  Message.swift
//  CloudKit
//
//  Created by Joshua Bates on 6/18/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

struct Message {
    
    let messageText: String
    let date: NSDate
   // let userID: String
}

extension Message {
    static var dateKey: String { return "Date" }
    static var messageTextKey: String { return "MessageText" }
    static var userIDKey: String { return "UserID" }
    static var recordType: String { return "Message" }
    
    init?(cloudKitRecord: CKRecord) {
        guard let messageText = cloudKitRecord[Message.messageTextKey] as? String,
            date = cloudKitRecord[Message.dateKey] as? NSDate
            // userID = cloudKitRecord[Message.userIDKey] as? String
            where cloudKitRecord.recordType == Message.recordType else { return nil }
        
        self.init(messageText: messageText, date: date /*userID: userID*/)
    }
}

extension CKRecord {
    convenience init(message: Message) {
        self.init(recordType: Message.recordType)
        self[Message.messageTextKey] = message.messageText
        self[Message.dateKey] = message.date
        //self[Message.userIDKey] = message.userID
    }
}
