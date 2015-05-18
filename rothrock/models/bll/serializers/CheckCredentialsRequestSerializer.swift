//
//  CheckCredentialsRequestSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ICheckCredentialsRequestSerializer: IJSONSerializer {
    typealias T = CheckCredentialsRequest
    
    public func serialize(t: CheckCredentialsRequest) -> JSON {
        return nil
    }
}

internal class CheckCredentialsRequestSerializer: ICheckCredentialsRequestSerializer {
    
    override func serialize(src: CheckCredentialsRequest) -> JSON {
        return JSON(
            [
                "email": src.email,
                "password": src.password,
                "remember_me": 1
            ]
        )
    }
}