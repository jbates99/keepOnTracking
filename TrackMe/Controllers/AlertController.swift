//
//  AlertController.swift
//  TrackMe
//
//  Created by Joshua Bates on 7/20/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation

struct AlertController {
    
    static func displayError(error: NSError?, withMessage message: String?) {
        if let error = error {
            print(error)
        }
    }
    
}
