//
//  IVenueBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IVenueBusiness {
    func get(id: Int, success: (Venue?) -> Void, failure: (String) -> Void)
    
    func cleanDatabase()
}