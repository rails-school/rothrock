//
//  IRailsSchoolAPI.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IRailsSchoolAPI {
    func getFutureLessonSlugs(callback: RemoteCallback<[String]>)
    
    func getLesson(slug: String, callback: RemoteCallback<Lesson>)
    
    func getSchoolClass(slug: String, callback: RemoteCallback<SchoolClass>)
    
    func getUpcomingLesson(callback: RemoteCallback<Lesson>)
    
    func getUser(id: Int, callback: RemoteCallback<User>)
}