//
//  IUserBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IUserBusiness {
    func get(id: Int, success: (User?) -> Void, failure: (String) -> Void)
    
    func isCurrentUserAttendingTo(lessonSlug: String, isAttending: (Bool) -> Void, needToSignIn: () -> Void, failure: (String) -> Void)
    
    func toggleAttendance(lessonId: Int, newValue: Bool, success: () -> Void, failure: (String) -> Void)
    
    func checkCredentials(email: String, password: String, success: () -> Void, failure: (String) -> Void)
    
    func isSignedIn() -> Bool
    
    func logOut(success: () -> Void, failure: (String) -> Void)
    
    func getCurrentUserEmail() -> String?
    
    func getCurrentUserSchoolId() -> Int?
    
    func getCurrentUserSchoolSlug() -> String
    
    func saveDeviceToken(token: NSData)
    
    func cleanDatabase()
}