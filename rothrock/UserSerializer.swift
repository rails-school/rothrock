//
//  UserSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class UserSerializer: IJSONDeserializer {
    typealias T = User
    
    func deserialize(json: JSON) -> User {
        var outcome = User()
        
        outcome.id = json["id"].intValue
        outcome.name = json["name"].stringValue
        outcome.email = json["email"].stringValue
        outcome.teacher = json["teacher"].boolValue
        outcome.hideLastName = json["hide_last_name"].boolValue
        
        return outcome
    }
}