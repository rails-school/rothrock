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
    
    // Reference is needed, otherwise the manager is removed by the 
    // garbage collector
    private var _authenticatedManager: Alamofire.Manager?
    
    private func _getRoute(path: String) -> String {
        return RailsSchoolAPI.ADDRESS + path + RailsSchoolAPI.FORMAT
    }
    
    private func _getLessonRoute(path: String) -> String {
        return _getRoute("/l" + path)
    }
    
    private func _getUserRoute(path: String) -> String {
        return _getRoute("/users" + path)
    }
    
    private func _setAuthenticationCookie(cookieValue: String) -> Alamofire.Manager {
        if (_authenticatedManager != nil) {
            return _authenticatedManager!
        } else {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            var cookie = NSHTTPCookie(properties: [
                NSHTTPCookiePath: "/",
                NSHTTPCookieName: "remember_user_token",
                NSHTTPCookieValue: cookieValue,
                NSHTTPCookieOriginURL: "api_endpoint".localized
                ])!
            
            configuration.HTTPCookieStorage!.setCookie(cookie)
            
            _authenticatedManager = Alamofire.Manager(configuration: configuration)
            return _authenticatedManager!
        }
    }
    
    func getFutureLessonSlugs(callback: RemoteCallback<[String]>) {
          Alamofire
            .request(.GET, _getLessonRoute("/future/slugs"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(ArraySerializer(objectSerializer: SerializerFactory.provideString()))
        )
    }
    
    func getFutureLessonSlugs(schoolId: Int, callback: RemoteCallback<[String]>) {
        Alamofire
            .request(.GET, _getLessonRoute("/future/slugs/\(schoolId)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(ArraySerializer(objectSerializer: SerializerFactory.provideString()))
        )
    }
    
    func getLesson(slug: String, callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/\(slug)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideLesson())
            )
    }
    
    func getSchoolClass(slug: String, callback: RemoteCallback<SchoolClass>) {
        Alamofire
            .request(.GET, _getLessonRoute("/\(slug)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideSchoolClass())
            )
    }
    
    func getUpcomingLesson(callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/upcoming"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideLesson())
            )
    }
    
    func getUpcomingLesson(schoolId: Int, callback: RemoteCallback<Lesson>) {
        Alamofire
            .request(.GET, _getLessonRoute("/upcoming/\(schoolId)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideLesson())
            )
    }
    
    func getUser(id: Int, callback: RemoteCallback<User>) {
        Alamofire
            .request(.GET, _getUserRoute("/\(id)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideUser())
        )
    }
    
    func checkCredentials(request: CheckCredentialsRequest, callback: RemoteCallback<User>) {
        var data = [
            "user": [
                "email": request.email,
                "password": request.password,
                "remember_me": 1
            ]
        ]
        
        Alamofire
            .request(.POST, _getUserRoute("/sign_in"), parameters: data, encoding: .JSON)
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideUser())
            )
    }
    
    func signOut(callback: RemoteCallback<Void>) {
        Alamofire
            .request(.DELETE, _getUserRoute("/sign_out"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler()
            )
    }
    
    func saveDeviceToken(token: String, callback: RemoteCallback<Void>) {
        var data = [
            "token": token
        ]
        
        Alamofire
            .request(.PUT, _getUserRoute("/device-token"), parameters: data, encoding: .JSON)
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler()
            )
    }
    
    func getVenue(id: Int, callback: RemoteCallback<Venue>) {
        Alamofire
            .request(.GET, _getRoute("/venues/\(id)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideVenue())
            )
    }
    
    func isAttending(slug: String, authenticationCookie: String, callback: RemoteCallback<Bool>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.GET, _getRoute("/attending_lesson/\(slug)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler(SerializerFactory.provideBool())
            )
    }
    
    func attend(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.POST, _getRoute("/rsvp/\(lessonId)"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler()
            )
    }
    
    func removeAttendance(lessonId: Int, authenticationCookie: String, callback: RemoteCallback<Void>) {
        _setAuthenticationCookie(authenticationCookie)
            .request(.POST, _getRoute("/rsvp/\(lessonId)/delete"))
            .responseJSON(
                options: NSJSONReadingOptions.AllowFragments,
                completionHandler: callback.asHandler()
            )
    }
}