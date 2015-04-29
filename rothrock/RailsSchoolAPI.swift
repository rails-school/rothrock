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
    private static var ADDRESS = "https://railsschool.org"
    private static var FORMAT = ".json"
    
    private func _getRoute(path: String) -> String {
        return RailsSchoolAPI.ADDRESS + path + RailsSchoolAPI.FORMAT
    }
    
    private func _getLessonRoute(path: String) -> String {
        return _getRoute("/l" + path)
    }
    
    private func _getUserRoute(path: String) -> String {
        return _getRoute("/users" + path)
    }
    
    func getFutureLessonSlugs(callback: RemoteCallback<[String]>) {
          Alamofire
            .request(.GET, _getLessonRoute("/future/slugs"))
            .response(callback.asHandler(ArraySerializer(objectSerializer: StringSerializer())))
    }
    
    func getLesson(slug: String, callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/\(slug)"))
            .response(callback.asHandler(SerializerFactory.lesson))
    }
    
    func getSchoolClass(slug: String, callback: RemoteCallback<SchoolClass>) {
        Alamofire
            .request(.GET, _getLessonRoute("/\(slug)"))
            .response(callback.asHandler(SerializerFactory.schoolClass))
    }
    
    func getUpcomingLesson(callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/upcoming"))
            .response(callback.asHandler(SerializerFactory.lesson))
    }
    
    func getUser(id: Int, callback: RemoteCallback<User>) {
        Alamofire
            .request(.GET, _getUserRoute("/\(id)"))
            .response(callback.asHandler(SerializerFactory.user))
    }
    
    func checkCredentials(request: CheckCredentialsRequest, callback: RemoteCallback<Void>) {
        
    }
    
    func getVenue(id: Int, callback: RemoteCallback<Venue>) {
        
    }
    
    func isAttending(slug: String, callback: RemoteCallback<Bool>) {
        
    }
    
    func attend(lessonId: Int, callback: RemoteCallback<Void>) {
        
    }
    
    func removeAttendance(lessonId: Int, callback: RemoteCallback<Void>) {
        
    }
}