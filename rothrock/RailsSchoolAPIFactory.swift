//
//  RailsSchoolAPIFactory.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class RailsSchoolAPIFactory {
    private static var _api: IRailsSchoolAPI?
    
    public static var api: IRailsSchoolAPI {
        if let o = _api {
            return o
        } else {
            _api = RailsSchoolAPI()
            return self.api
        }
    }
}