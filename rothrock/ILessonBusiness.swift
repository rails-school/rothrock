//
//  ILessonBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol ILessonBusiness {
    func sortFutureSlugsByDate(success: ([String]?) -> Void, failure: (String) -> Void)
    
    func get(lessonSlug: String, success: (Lesson?) -> Void, failure: (String) -> Void)
    
    func getTuple(lessongSlug: String, success: (Lesson?, User?, Venue?) -> Void, failure: (String) -> Void)
    
    func getSchoolClassTuple(lessonSlug: String, success: (SchoolClass?, User?, Venue?) -> Void, failure: (String) -> Void)
    
    func getUpcoming(success: (Lesson?) -> Void)
    
    func engineAlarms(twoHourAlarm: (Lesson?) -> Void, dayAlarm: (Lesson?) -> Void)
}