//
//  Lesson.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class Lesson: RLMObject {
    public dynamic var slug: String?
    public dynamic var title: String?
    public dynamic var summary: String?
    public dynamic var lessonDescription: String?
    public dynamic var startTime: NSDate?
    public dynamic var endTime: NSDate?
    public dynamic var teacherId: Int = 0
    public dynamic var venueId: Int = 0
    public dynamic var updateDate: NSDate?
    
    public override class func primaryKey() -> String {
        return "slug"
    }
}