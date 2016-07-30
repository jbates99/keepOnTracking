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
    
    let followingController = FollowingController.sharedController
    let connectionGroup = dispatch_group_create()
    
    var connections: [Connections]?
    var queryResults: [CKRecord]?
    var recordInfoDictionary: [CKRecord: CKDiscoveredUserInfo]?
    var infoMessagesDictionary: [CKDiscoveredUserInfo: Message?]?
    
    
    var filteredResults: [CKRecord]? {
        guard let queryResults = queryResults else { return nil }
        return queryResults.filter { $0.creatorUserRecordID?.recordName == "__defaultOwner__" }
    }
    
    func setUpConnections(currentUserID: CKRecordID, completion: (connections: [Connections]?) -> Void) {
        setUpQueryResults(currentUserID) { records in
            if let records = records {
                self.setUpRecordInfoDictionary(records) { dictionary in
                    if let dictionary = dictionary {
                        self.setUpInfoMessagesDictionary(dictionary) { infoDictionary in
                            if let infoDictionary = infoDictionary {
                                self.connectionsForUser(infoDictionary) { connections in
                                    completion(connections: connections)
                                    NSNotificationCenter.defaultCenter().postNotificationName("connectionsSet", object: nil)
                                }
                            } else {
                                completion(connections: nil)
                            }
                        }
                    } else {
                        completion(connections: nil)
                    }
                }
            } else {
                completion(connections: nil)
            }
        }
    
    }
    
    func setUpQueryResults(currentUserID: CKRecordID, completion: (records: [CKRecord]?) -> Void) {
        dispatch_group_enter(connectionGroup)
        followingController.retrieveFollowingsRequestsByStatus(1, recordID: currentUserID) { returnedRecords in
            if let returnedRecords = returnedRecords {
                let filteredRecords = returnedRecords.filter { $0.creatorUserRecordID?.recordName == "__defaultOwner__" }
                self.queryResults = filteredRecords
                completion(records: filteredRecords)
            } else {
                completion(records: nil)
            }
            dispatch_group_leave(self.connectionGroup)
        }
    }
    
    func setUpRecordInfoDictionary(records: [CKRecord], completion: (dictionary: [CKRecord: CKDiscoveredUserInfo]?) -> Void) {
        dispatch_group_enter(connectionGroup)
        var dictionary = [CKRecord: CKDiscoveredUserInfo]()
        for record in records {
            guard let userInfo = NotificationController.sharedInstance.creatorUserInfo(for: record) else { break }
            dictionary[record] = userInfo
        }
        self.recordInfoDictionary = dictionary
        completion(dictionary: dictionary)
        dispatch_group_leave(self.connectionGroup)
    }
    
    
    func setUpInfoMessagesDictionary(dictionary: [CKRecord: CKDiscoveredUserInfo], completion: (infoDictionary: [CKDiscoveredUserInfo: Message?]?) -> Void) {
        dispatch_group_enter(connectionGroup)
        var infoDictionary = [CKDiscoveredUserInfo: Message?]()
        for record in dictionary.values {
            guard let recordID = record.userRecordID else { break }
            MessageController.sharedController.fetchLatestUserUpdateMessage(recordID) { message in
                if let message = message {
                    infoDictionary[record] = message
                } else {
                    infoDictionary[record] = nil
                }
            }
            self.infoMessagesDictionary = infoDictionary
            completion(infoDictionary: infoDictionary)
            dispatch_group_leave(self.connectionGroup)
        }
        
    }
    
    func connectionsForUser(dictionary: [CKDiscoveredUserInfo: Message?], completion: (connections: [Connections]) -> Void) {
        dispatch_group_enter(connectionGroup)
        var connections = [Connections]()
        for item in dictionary {
            createConnection(item.1, userInfo: item.0) { connection in
                connections.append(connection)
            }
        }
        self.connections = connections
        completion(connections: connections)
        dispatch_group_leave(self.connectionGroup)
    }
    
    func createConnection(message: Message?, userInfo: CKDiscoveredUserInfo, completion: (connection: Connections) -> Void) {
        var messageText: String?
        guard let contact = userInfo.displayContact, userRecordID = userInfo.userRecordID else { return }
        let name = "\(contact.givenName) \(contact.familyName)"
        let userID = String(userRecordID)
        if let message = message {
            messageText = "\(message.messageText) at \(message.date)"
        } else {
            messageText = nil
        }
        let connection = Connections(name: name, message: messageText, userID: userID)
        completion(connection: connection)
    }
    
}
