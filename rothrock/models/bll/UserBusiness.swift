//
//  UserBusiness.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import Regex

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
        // Log out first, otherwise the token will not be present
        logOut(
            {
                self.api.checkCredentials(
                    CheckCredentialsRequest(email: email, password: password),
                    callback: RemoteCallback<User>(
                        success: { (response, user) in
                            var authenticationCookie: String?
                            
                            for (key, value) in response!.allHeaderFields {
                                var headerName = key as! String
                                var headerValue = value as! String
                                
                                if headerName == "Set-Cookie" {
                                    // Question mark is used as an ungreedy flag
                                    let match = headerValue.grep("remember_user_token=(.+?);")
                                    
                                    if match.captures.count > 0 {
                                        let capture = match.captures[0]
                                        authenticationCookie = capture[count("remember_user_token=")..<(count(capture) - 1)]
                                    }
                                }
                            }
                            
                            if let c = authenticationCookie {
                                self._userDAO.setCurrentUserEmail(email)
                                self._userDAO.setCurrentUserToken(c)
                                self._userDAO.setCurrentUserSchoolId(user!.schoolId)
                                success()
                            } else {
                                NSLog("%@: %@", NSStringFromClass(UserBusiness.self), "Expected cookie was not found")
                                failure(self.getDefaultErrorMsg())
                            }
                        },
                        failure: { (response, error) in
                            if response!.statusCode == 401 {
                                failure("settings_invalid_credentials".localized)
                            } else {
                                self.processError(error, failure: failure)
                            }
                        }
                    )
                )
            },
            failure: failure
        )
    }
    
    func logOut(success: () -> Void, failure: (String) -> Void) {
        api.signOut(BLLCallback<Void>(
            base: self,
            success: { _, _ in
                self._userDAO.logOut()
                success()
            },
            failure: failure
            )
        )
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
    
    func saveDeviceToken(token: NSData) {
        api.saveDeviceToken(
            "\(token)",
            callback: BLLCallback<Void>(
                base: self,
                success: { _, _ in NSLog("%@: Device token successfully saved", NSStringFromClass(UserBusiness.self)) },
                failure: { NSLog("%@ - Error when saving device token: %@", NSStringFromClass(UserBusiness.self), $0) }
            )
        )
    }
}