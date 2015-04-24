//
//  UserDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class UserDAO: BaseDAO, IUserDAO {
    private static let USERNAME_KEY = "username",
        TOKEN_KEY = "token"
    
    private var _preferenceDAL: NSUserDefaults
    
    override init(dal: RLMRealm) {
        super.init(dal: dal)
        
        self._preferenceDAL = NSUserDefaults.standardUserDefaults()
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
        User.createOrUpdateInRealm(getDAL(), withObject: user)
        getDAL().commitWriteTransaction()
    }
    
    func getCurrentUsername() -> String? {
        return _preferenceDAL.stringForKey(UserDAO.USERNAME_KEY)
    }
    
    func setCurrentUsername(value: String) {
        _preferenceDAL.setObject(value, forKey: UserDAO.USERNAME_KEY)
    }
    
    func getCurrentUserToken() -> String? {
        return _preferenceDAL.stringForKey(UserDAO.TOKEN_KEY)
    }
    
    func setCurrentUserToken(value: String) {
        _preferenceDAL.stringForKey(UserDAO.TOKEN_KEY)
    }
}