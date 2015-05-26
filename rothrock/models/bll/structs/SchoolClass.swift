//
//  SchoolClass.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class SchoolClass {
    public var lesson: Lesson?
    public var students: [User]?
    
    public func toDictionary() -> NSDictionary {
        return [
            "lesson": lesson!.toDictionary(),
            "students": students!.count
        ]
    }
}