//
//  CheckCredentialsRequestSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class CheckCredentialsRequestSerializer: IJSONSerializer {
    typealias T = CheckCredentialsRequest
    
    func serialize(src: CheckCredentialsRequest) -> JSON {
        var wrapper = JSON(src), content = JSON(src)
        
        content["email"] = JSON(src.email!)
        content["password"] = JSON(src.password!)
        content["remember_me"] = 1
        
        wrapper["user"] = content
        
        return wrapper
    }
}