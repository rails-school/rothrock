//
//  StringSerializer.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class StringSerializer: IJSONDeserializer {
    typealias DeserializedType = String
    
    func deserialize(json: JSON) -> String {
        return json.stringValue
    }
}