//
//  BaseDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class BaseDAO {
    private var _dal: RLMRealm
    
    internal init(dal: RLMRealm) {
        self._dal = dal
    }
    
    internal func getDAL() -> RLMRealm {
        return _dal
    }
}