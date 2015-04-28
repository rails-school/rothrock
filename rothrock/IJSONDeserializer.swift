//
//  IDeserializer.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol IJSONDeserializer {
    typealias DeserializedType
    
    func deserialize(json: JSON) -> DeserializedType
}