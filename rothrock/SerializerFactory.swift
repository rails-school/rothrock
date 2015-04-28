//
//  SerializerFactory.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class SerializerFactory {
    private static var _checkCredentialsRequest: CheckCredentialsRequestSerializer?
    
    public class func checkCredentialsRequest<T: IJSONSerializer where T.SerializedType == CheckCredentialsRequest>() -> T {
        if let t = _checkCredentialsRequest {
            return t as! T
        } else {
            _checkCredentialsRequest = CheckCredentialsRequestSerializer()
            return _checkCredentialsRequest! as! T
        }
    }
}