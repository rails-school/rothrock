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
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        return formatter.dateFromString(string)
    }
    
    public func isInInterval(start: NSDate, end: NSDate) -> Bool {
        return self.isLaterThanOrEqualTo(start) && self.isEarlierThanOrEqualTo(end)
    }
}