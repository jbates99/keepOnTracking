//
//  DateHelpers.swift
//  TrackMe
//
//  Created by Joshua Bates on 8/2/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import Foundation

extension NSDate {
    
    func stringValue() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        
        return formatter.stringFromDate(self)
    }
    
}
