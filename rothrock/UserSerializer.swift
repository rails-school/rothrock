//
//  UserSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IUserDeserializer: IJSONDeserializer {
    typealias T = User
    
    public func deserialize(json: JSON) -> User {
        return User()
    }
}

internal class UserSerializer: IUserDeserializer {
    
    override func deserialize(json: JSON) -> User {
        var outcome = User()
        
        outcome.id = json["id"].intValue
        outcome.name = json["name"].stringValue
        outcome.email = json["email"].stringValue
        outcome.teacher = json["teacher"].boolValue
        outcome.hideLastName = json["hide_last_name"].boolValue
        
        return outcome
    }
}