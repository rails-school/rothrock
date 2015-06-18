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
    
    public func shortMonth()  -> String {
        let months = [
            "Jan", "Feb", "Mar", "Apr", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ]
        
        return months[self.month() - 1]
    }
    
    public func userFriendly() -> String {
        if self.isLaterThanOrEqualTo(NSDate()) {
            var outcome = "in "
            var pivot: Int = 0
            
            if self.secondsUntil() <= 0 {
                return "now"
            } else if self.secondsUntil() < 60 {
                pivot = Int(self.secondsUntil())
                outcome += "\(pivot) second"
            } else if self.minutesUntil() < 60 {
                pivot = Int(self.minutesUntil())
                outcome += "\(pivot) minute"
            } else if self.hoursUntil() < 24 {
                pivot = Int(self.hoursUntil())
                outcome += "\(pivot) hour"
            } else {
                pivot = self.daysUntil()
                outcome += "\(pivot) day"
            }
            
            if pivot > 1 { // Plural form
                outcome += "s"
            }
            
            return outcome
        } else {
            var outcome = ""
            var pivot: Int = 0
            
            if self.hoursAgo() >= 24 {
                pivot = Int(self.daysAgo())
                outcome += "\(pivot) day"
            } else if self.minutesAgo() >= 60 {
                pivot = Int(self.hoursAgo())
                outcome += "\(pivot) hour"
            } else if self.secondsAgo() >= 60 {
                pivot = Int(self.minutesAgo())
                outcome += "\(pivot) minute"
            } else {
                pivot = Int(self.secondsAgo())
                outcome += "\(pivot) second"
            }
            
            if pivot > 1 { // Plural form
                outcome += "s"
            }
            
            outcome += " ago"
            
            return outcome
        }
    }
}