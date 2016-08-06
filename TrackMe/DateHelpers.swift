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
        formatter.timeStyle = .ShortStyle
        
        
        return formatter.stringFromDate(self)
    }
    
}

extension NSDate {
    
    func offsetFrom(date:NSDate = NSDate()) -> String {
        
        let dayHourMinuteSecond: NSCalendarUnit = [.Day, .Hour, .Minute, .Second]
        let difference = NSCalendar.currentCalendar().components(dayHourMinuteSecond, fromDate: date, toDate: self, options: [])
        
        let seconds = "\(difference.second)s"
        let minutes = "\(difference.minute)m" + " " + seconds
        let hours = "\(difference.hour)h" + " " + minutes
        let days = "\(difference.day)d" + " " + hours
        
        if difference.day    > 0 { return days }
        if difference.hour   > 0 { return hours }
        if difference.minute > 0 { return minutes }
        if difference.second > 0 { return seconds }
        return ""
    }
    
}