//
//  DateExtension.swift
//  rothrock
//
//  Created by Adrien on 14/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

extension NSDate {
    public class func fromString(string: String) -> NSDate? {
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return formatter.dateFromString(string)
    }
    
    public func isInInterval(start: NSDate, end: NSDate) -> Bool {
        return self.isLaterThanOrEqualTo(start) && self.isEarlierThanOrEqualTo(end)
    }
    
    public func userFriendly() -> String {
        if self.isLaterThan(NSDate()) {
            var minutes = "\(self.minute())"
            
            if self.minute() < 10 {
                minutes = "0" + minutes
            }
            
            return "\(self.month())/\(self.day())/\(self.year()) - \(self.hour()):\(minutes)"
        } else {
            return self.timeAgoSinceNow()
        }
    }
    
    public class func userFriendly(value: String) -> String {
        return fromString(value)!.userFriendly()
    }
}