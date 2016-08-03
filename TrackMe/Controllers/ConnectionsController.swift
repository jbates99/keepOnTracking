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
    
    let delegateUserSetUpGroup = dispatch_group_create()
    
    let followingController = FollowingController.sharedController
    
    var connections: [Connections]?
    var queryResults: [CKRecord]?
    var recordInfoDictionary: [CKRecord: CKDiscoveredUserInfo]?
    var infoMessagesDictionary: [CKDiscoveredUserInfo: Message?]?
    
    
    var filteredResults: [CKRecord]? {
        guard let queryResults = queryResults else { return nil }
        return queryResults.filter { $0.creatorUserRecordID?.recordName == "__defaultOwner__" }
    }
    
    
    //MAIN
    func setUpConnections(currentUserID: CKRecordID, completion: (connections: [Connections]?) -> Void) {
        setUpQueryResults(currentUserID) { records in
            guard let followingRecords = records else { completion(connections: nil); return }
            
            self.setUpRecordInfoDictionary(followingRecords, completion: { (dictionary) in
                guard let followingRecordsUserInfoDictionary = dictionary else { completion(connections: nil); return }
                
                self.setUpInfoMessagesDictionary(followingRecordsUserInfoDictionary, completion: { (infoDictionary) in
                    guard let infoMessageDictionary = infoDictionary else { completion(connections: nil); return }
                    
                    let connections = self.connectionsForUser(infoMessageDictionary)
                    completion(connections: connections)
                    NSNotificationCenter.defaultCenter().postNotificationName("connectionsSet", object: nil)
                })
            })
        }
    }
    
    
    //HELPERS
    func setUpQueryResults(currentUserID: CKRecordID, completion: (records: [CKRecord]?) -> Void) {
        followingController.retrieveFollowingsRequestsByStatusForUser(1) { returnedRecords in
            if let returnedRecords = returnedRecords {
                self.queryResults = returnedRecords
                completion(records: returnedRecords)
            } else {
                completion(records: nil)
            }
        }
    }
    
    func setUpRecordInfoDictionary(records: [CKRecord], completion: (dictionary: [CKRecord: CKDiscoveredUserInfo]?) -> Void) {
        let recordInfoDispatchGroup = dispatch_group_create()
        var dictionary = [CKRecord: CKDiscoveredUserInfo]()
        for record in records {
            dispatch_group_enter(recordInfoDispatchGroup)
            NotificationController.sharedInstance.creatorUserInfo(for: record, completion: { (discoveredInfo) in
                dictionary[record] = discoveredInfo
                dispatch_group_leave(recordInfoDispatchGroup)
            })
        }
        self.recordInfoDictionary = dictionary
        dispatch_group_notify(recordInfoDispatchGroup, dispatch_get_main_queue()) {
            completion(dictionary: dictionary)
        }
    }
    
    
    func setUpInfoMessagesDictionary(dictionary: [CKRecord: CKDiscoveredUserInfo], completion: (infoDictionary: [CKDiscoveredUserInfo: Message?]?) -> Void) {
        var infoDictionary = [CKDiscoveredUserInfo: Message?]()
        
        let messageDictionaryDispatchGroup = dispatch_group_create()
        
        for record in dictionary.values {
            guard let recordID = record.userRecordID else { break }
            dispatch_group_enter(messageDictionaryDispatchGroup)
            MessageController.sharedController.fetchLatestUserUpdateMessage(recordID) { message in
                if let message = message {
                    infoDictionary[record] = message
                } else {
                    infoDictionary[record] = Message(messageText: "No recent updates found", date: NSDate())
                }
                self.infoMessagesDictionary = infoDictionary
                dispatch_group_leave(messageDictionaryDispatchGroup)
            }
        }
        
        dispatch_group_notify(messageDictionaryDispatchGroup, dispatch_get_main_queue()) { 
            completion(infoDictionary: infoDictionary)
        }
    }
    
    func connectionsForUser(dictionary: [CKDiscoveredUserInfo: Message?]) -> [Connections] {
        var connections = [Connections]()
        for item in dictionary {
            let newConnection = createConnection(item.1, userInfo: item.0)
            guard let connection = newConnection else { break }
            connections.append(connection)
        }
        self.connections = connections
        return connections
    }
    
    func createConnection(message: Message?, userInfo: CKDiscoveredUserInfo) -> Connections? {
        var messageText: String?
        guard let contact = userInfo.displayContact, userRecordID = userInfo.userRecordID else { return nil }
        let name = "\(contact.givenName) \(contact.familyName)"
        let userID = userRecordID
        if let message = message {
            messageText = "\(message.messageText) at \(message.date.stringValue())"
        } else {
            messageText = nil
        }
        let connection = Connections(name: name, message: messageText, userID: userID)
        return connection
    }
    
}
