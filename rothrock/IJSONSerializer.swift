//
//  IJSONSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol IJSONSerializer {
    typealias SerializedType
    
    func serialize(t: SerializedType) -> JSON
}