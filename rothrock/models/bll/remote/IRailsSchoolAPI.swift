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
    
    func getFutureLessonSlugs(schoolId: Int, callback: RemoteCallback<[String]>)
    
    func getLesson(slug: String, callback: RemoteCallback<Lesson>)
    
    func getSchoolClass(slug: String, callback: RemoteCallback<SchoolClass>)
    
    func getUpcomingLesson(callback: RemoteCallback<Lesson>)
    
    func getUpcomingLesson(schoolId: Int, callback: RemoteCallback<Lesson>)
    
    func getUser(id: Int, callback: RemoteCallback<User>)
    
    func checkCredentials(request: CheckCredentialsRequest, callback: RemoteCallback<User>)
    
    func signOut(callback: RemoteCallback<Void>)
    
    func saveDeviceToken(token: String, callback: RemoteCallback<Void>)
    
    func getVenue(id: Int, callback: RemoteCallback<Venue>)
    
    func isAttending(slug: String, authenticationCookie: String, callback: RemoteCallback<Bool>)
    
    func attend(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>)
    
    func removeAttendance(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>)
}