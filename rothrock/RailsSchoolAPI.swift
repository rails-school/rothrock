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
    private static var ADDRESS = "api_endpoint".localized
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
    
    private func _setAuthenticationCookie(cookie: String) -> Alamofire.Manager {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        defaultHeaders["Cookie"] = "remember_user_token"
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        return Alamofire.Manager(configuration: configuration)
    }
    
    func getFutureLessonSlugs(callback: RemoteCallback<[String]>) {
          Alamofire
            .request(.GET, _getLessonRoute("/future/slugs"))
            .response(callback.asHandler(ArraySerializer(objectSerializer: SerializerFactory.string)))
    }
    
    func getFutureLessonSlugs(schoolId: Int, callback: RemoteCallback<[String]>) {
        Alamofire
            .request(.GET, _getLessonRoute("/future/slugs/\(schoolId)"))
            .response(callback.asHandler(ArraySerializer(objectSerializer: SerializerFactory.string)))
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
    
    func getUpcomingLesson(schoolId: Int, callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/upcoming/\(schoolId)"))
            .response(callback.asHandler(SerializerFactory.lesson))
    }
    
    func getUser(id: Int, callback: RemoteCallback<User>) {
        Alamofire
            .request(.GET, _getUserRoute("/\(id)"))
            .response(callback.asHandler(SerializerFactory.user))
    }
    
    func checkCredentials(request: CheckCredentialsRequest, callback: RemoteCallback<Void>) {
        var request: AnyObject = SerializerFactory.checkCredentialsRequest.serialize(request).dictionaryObject as! AnyObject
        
        Alamofire
            .request(.POST, _getUserRoute("/sign_in"), parameters: ["user": request], encoding: .JSON)
            .response(callback.asHandler())
    }
    
    func getVenue(id: Int, callback: RemoteCallback<Venue>) {
        Alamofire
            .request(.GET, _getRoute("/venues/\(id)"))
            .response(callback.asHandler(SerializerFactory.venue))
    }
    
    func isAttending(slug: String, authenticationCookie: String, callback: RemoteCallback<Bool>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.GET, _getRoute("/attending_lesson/\(slug)"))
            .response(callback.asHandler(SerializerFactory.bool))
    }
    
    func attend(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.GET, _getRoute("/rsvp/\(lessonId)"))
            .response(callback.asHandler())
    }
    
    func removeAttendance(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.GET, _getRoute("/rsvp/\(lessonId)/delete"))
            .response(callback.asHandler())
    }
}