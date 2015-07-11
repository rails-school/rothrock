//
//  UserDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class UserDAO: BaseDAO, IUserDAO {
    private static let EMAIL_KEY = "current_user_email",
        SCHOOL_ID_KEY = "current_user_school_id",
        TOKEN_KEY = "current_user_token",
        LATEST_CLEAN_KEY = "latest_clean"
    
    private var _keyValueDAL: NSUserDefaults
    
    init(dal: RLMRealm, keyValueStorage: NSUserDefaults) {
        self._keyValueDAL = keyValueStorage
        
        super.init(dal: dal)
    }
    
    func exists(id: Int) -> Bool {
        if let u = find(id) {
            return true
        } else {
            return false
        }
    }
    
    func find(id: Int) -> User? {
        var pred = NSPredicate(format: "id = %d", id)
        return User.objectsInRealm(dal, withPredicate: pred).firstObject() as! User?
    }
    
    func save(user: User) {
        dal.beginWriteTransaction()
        
        if exists(user.id) {
            var e: User = find(user.id)!
            
            // Optional fields from server. If they are blank, do not update local entry.
            if user.name != nil && !user.name!.isEmpty {
                e.name = user.name
            }
            if user.email != nil && !user.email!.isEmpty {
                e.email = user.email
            }
            
            e.hideLastName = user.hideLastName
            e.updateDate = NSDate()
            
            User.createOrUpdateInRealm(dal, withValue: e)
        } else {
            user.updateDate = NSDate()
            User.createInRealm(dal, withValue: user)
        }
        
        dal.commitWriteTransaction()
    }
    
    internal func delete(user: User) {
        dal.beginWriteTransaction()
        dal.deleteObject(user)
        dal.commitWriteTransaction()
    }
    
    func getCurrentUserEmail() -> String? {
        return _keyValueDAL.stringForKey(UserDAO.EMAIL_KEY)
    }
    
    func setCurrentUserEmail(value: String) {
        _keyValueDAL.setObject(value, forKey: UserDAO.EMAIL_KEY)
    }
    
    func getCurrentUserToken() -> String? {
        return _keyValueDAL.stringForKey(UserDAO.TOKEN_KEY)
    }
    
    func setCurrentUserToken(value: String) {
        _keyValueDAL.setObject(value, forKey: UserDAO.TOKEN_KEY)
    }
    
    func getCurrentUserSchoolId() -> Int? {
        return _keyValueDAL.objectForKey(UserDAO.SCHOOL_ID_KEY) as? Int
    }
    
    func setCurrentUserSchoolId(value: Int) {
        _keyValueDAL.setObject(value, forKey: UserDAO.SCHOOL_ID_KEY)
    }
    
    func hasCurrentUser() -> Bool {
        var e = getCurrentUserEmail()
        var g = getCurrentUserToken()
        return getCurrentUserEmail() != nil && getCurrentUserToken() != nil
    }
    
    func logOut() {
        _keyValueDAL.removeObjectForKey(UserDAO.EMAIL_KEY)
        _keyValueDAL.removeObjectForKey(UserDAO.TOKEN_KEY)
    }
    
    func getLatestClean() -> NSDate? {
        var date = _keyValueDAL.objectForKey(UserDAO.LATEST_CLEAN_KEY) as? String
        
        if let d = date {
            return NSDate.fromString(d)
        } else {
            return nil
        }
    }
    
    func truncateTable() {
        var users = User.allObjects()
        
        for i in 0..<users.count {
            delete(users.objectAtIndex(i) as! User)
        }
        
        _keyValueDAL.setObject(NSDate().toString(), forKey: UserDAO.LATEST_CLEAN_KEY)
    }
}