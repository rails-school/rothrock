//
//  RailsSchoolAPI.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import Alamofire

internal class RailsSchoolAPI: IRailsSchoolAPI {
    private static var ADDRESS = "https://railsschool.org/"
    
    func getFutureLessonSlugs(callback: RemoteCallback<[String]>) {
          Alamofire
            .request(.GET, RailsSchoolAPI.ADDRESS)
            .response(callback.asHandler(ArraySerializer(objectSerializer: StringSerializer())))
    }
    
    func getLesson(slug: String, callback: RemoteCallback<Lesson?>) {
        
    }
    
    func getSchoolClass(slug: String, callback: RemoteCallback<SchoolClass?>) {
        
    }
    
    func getUpcomingLesson(callback: RemoteCallback<Lesson?>) {
        
    }
    
    func getUser(id: Int, callback: RemoteCallback<User?>) {
        
    }
    
    func checkCredentials(request: CheckCredentialsRequest, callback: RemoteCallback<Void?>) {
        
    }
    
    func getVenue(id: Int, callback: RemoteCallback<Venue?>) {
        
    }
    
    func isAttending(slug: String, callback: RemoteCallback<Bool?>) {
        
    }
    
    func attend(lessonId: Int, callback: RemoteCallback<Void?>) {
        
    }
    
    func removeAttendance(lessonId: Int, callback: RemoteCallback<Void?>) {
        
    }
}