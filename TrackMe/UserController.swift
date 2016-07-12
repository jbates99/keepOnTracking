//
//  UserController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/9/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
   static let sharedInstance = UserController()
    
    var currentUser = User! {
        
    }
    
    let container = CKContainer.defaultContainer()
}