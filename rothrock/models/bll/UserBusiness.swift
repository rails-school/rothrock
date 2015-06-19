//
//  UserBusiness.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class UserBusiness: BaseBusiness, IUserBusiness {
    private static let COOLDOWN_SEC = 5 * 60
    
    private var _userDAO: IUserDAO
    
    internal init(api: IRailsSchoolAPI, userDAO: IUserDAO) {
        self._userDAO = userDAO
        
        super.init(api: api)
    }
    
    func get(id: Int, success: (User?) -> Void, failure: (String) -> Void) {
        if _userDAO.exists(id) {
            var u = _userDAO.find(id)
            
            success(u)
            
            if NSDate().dateBySubtractingSeconds(u!.updateDate!.second()).second() >= UserBusiness.COOLDOWN_SEC {
                api.getUser(id, callback: BLLCallback(base: self, success: { self._userDAO.save($1!) }, failure: failure))
            }
        } else {
            api.getUser(id, callback: BLLCallback(base: self, success: { success($1); self._userDAO.save($1!) }, failure: failure))
        }
    }
    
    func isCurrentUserAttendingTo(lessonSlug: String, isAttending: (Bool) -> Void, needToSignIn: () -> Void, failure: (String) -> Void) {
        if !isSignedIn() {
            needToSignIn()
        } else {
            api.isAttending(
                lessonSlug,
                authenticationCookie: _userDAO.getCurrentUserToken()!,
                callback: BLLCallback(base: self, success: { isAttending($1!) }, failure: failure)
            )
        }
    }
    
    func toggleAttendance(lessonId: Int, newValue: Bool, success: () -> Void, failure: (String) -> Void) {
        if !isSignedIn() {
            failure("error_not_signed_in".localized)
        } else {
            var callback = BLLCallback<Void>(base: self, success: { (response, o) in success() }, failure: failure)
            
            if newValue {
                api.attend(lessonId, authenticationCookie: _userDAO.getCurrentUserToken()!, callback: callback)
            } else {
                api.removeAttendance(lessonId, authenticationCookie: _userDAO.getCurrentUserToken()!, callback: callback)
            }
        }
    }
    
    func checkCredentials(email: String, password: String, success: () -> Void, failure: (String) -> Void) {
        api.checkCredentials(
            CheckCredentialsRequest(email: email, password: password),
            callback: RemoteCallback<User>(
                success: { (response, user) in
                    var authenticationCookie: String?
                    
                    for (key, value) in response!.allHeaderFields {
                        var headerName = "\(key)"
                        var headerValue = "\(value)"
                        
                        if headerName == "Set-Cookie" {
                            var regex: NSRegularExpression = NSRegularExpression(pattern: "remember_user_token=(.+)", options: NSRegularExpressionOptions(), error: NSErrorPointer())!
                            
                            if regex.numberOfMatchesInString(headerValue, options: NSMatchingOptions(), range: NSRangeFromString(headerValue)) > 0 {
                                authenticationCookie = "\(regex.firstMatchInString(headerValue, options: NSMatchingOptions(), range: NSRangeFromString(headerValue)))"
                            }
                        }
                    }
                    
                    if let c = authenticationCookie {
                        self._userDAO.setCurrentUserEmail(email)
                        self._userDAO.setCurrentUserToken(c)
                        self._userDAO.setCurrentUserSchoolId(user!.schoolId)
                    } else {
                        NSLog("%@: %@", NSStringFromClass(LessonBusiness.self), "Expected cookie was not found")
                        failure(self.getDefaultErrorMsg())
                    }
                },
                failure: { (response, error) in
                    if response!.statusCode == 401 && error != nil {
                        failure("settings_invalid_credentials".localized)
                    } else {
                        self.processError(error, failure: failure)
                    }
                }
            )
        )
    }
    
    func logOut() {
        _userDAO.logOut()
    }
    
    func isSignedIn() -> Bool {
        return _userDAO.hasCurrentUser()
    }
    
    func getCurrentUserEmail() -> String? {
        return _userDAO.getCurrentUserEmail()
    }
    
    func getCurrentUserSchoolId() -> Int? {
        return _userDAO.getCurrentUserSchoolId()
    }
    
    func getCurrentUserSchoolSlug() -> String {
        return (getCurrentUserSchoolId() == 1) ? "sf" : "cville"
    }
}