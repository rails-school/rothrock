//
//  User.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class User: RLMObject {
    public dynamic var id: Int = 0
    
    public dynamic var name: String?
    public dynamic var email: String?
    public dynamic var hideLastName: Bool = false
    public dynamic var schoolId: Int = 0
    public dynamic var updateDate: NSDate?
    
     public override class func primaryKey() -> String {
        return "id"
    }
    
    public var displayedName: String {
        var n = name!
        
        if hideLastName {
            var a: [String] = n.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).componentsSeparatedByString(" ")
            
            if a.count > 0 {
                return a[0]
            } else {
                return n
            }
        } else {
            return n
        }
    }
}