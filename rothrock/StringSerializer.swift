//
//  StringSerializer.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IStringDeserializer: IJSONDeserializer {
    typealias T = String
    
    public func deserialize(json: JSON) -> String {
        return ""
    }
}

internal class StringSerializer: IStringDeserializer {
    override func deserialize(json: JSON) -> String {
        return json.stringValue
    }
}