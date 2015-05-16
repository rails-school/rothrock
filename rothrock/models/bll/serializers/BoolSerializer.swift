//
//  BoolSerializer.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IBoolDeserializer: IJSONDeserializer {
    typealias T = Bool
    
    public func deserialize(json: JSON) -> Bool {
        return false
    }
}

internal class BoolSerializer: IBoolDeserializer {
    override func deserialize(json: JSON) -> Bool {
        return json.boolValue
    }
}