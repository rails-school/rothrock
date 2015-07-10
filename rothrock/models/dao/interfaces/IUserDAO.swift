//
//  IUserDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IUserDAO {
    func exists(id: Int) -> Bool
    
    func find(id: Int) -> User?
    
    func save(user: User)
    
    func getCurrentUserEmail() -> String?
    
    func setCurrentUserEmail(value: String)
    
    func getCurrentUserToken() -> String?
    
    func setCurrentUserToken(value: String)
    
    func getCurrentUserSchoolId() -> Int?
    
    func setCurrentUserSchoolId(value: Int)
    
    func hasCurrentUser() -> Bool
    
    func logOut()
    
    func truncateTable()
}