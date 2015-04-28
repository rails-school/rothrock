//
//  UserDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class UserDAO: BaseDAO, IUserDAO {
    private static let EMAIL_KEY = "email",
        TOKEN_KEY = "token"
    
    private var _preferenceDAL: NSUserDefaults
    
    init(dal: RLMRealm, preferenceStorage: NSUserDefaults) {
        self._preferenceDAL = preferenceStorage
        
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
        var pred = NSPredicate(format: "id = %@", id)
        return User.objectsInRealm(getDAL(), withPredicate: pred).firstObject() as! User?
    }
    
    func save(user: User) {
        getDAL().beginWriteTransaction()
        user.updateDate = NSDate()
        User.createOrUpdateInRealm(getDAL(), withObject: user)
        getDAL().commitWriteTransaction()
    }
    
    func getCurrentUserEmail() -> String? {
        return _preferenceDAL.stringForKey(UserDAO.EMAIL_KEY)
    }
    
    func setCurrentUserEmail(value: String) {
        _preferenceDAL.setObject(value, forKey: UserDAO.EMAIL_KEY)
    }
    
    func getCurrentUserToken() -> String? {
        return _preferenceDAL.stringForKey(UserDAO.TOKEN_KEY)
    }
    
    func setCurrentUserToken(value: String) {
        _preferenceDAL.stringForKey(UserDAO.TOKEN_KEY)
    }
    
    func hasCurrentUser() -> Bool {
        if let e = getCurrentUserEmail() {
            return true
        } else {
            return false
        }
    }
}