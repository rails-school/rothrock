//
//  ArraySerializer.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class ArraySerializer<T, A: IJSONDeserializer where A.DeserializedType == T>: IJSONDeserializer {
    typealias DeserializedType = [T]
    
    private var _objectSerializer: A
    
    init(objectSerializer: A) {
        self._objectSerializer = objectSerializer
    }
    
    func deserialize(json: JSON) -> [T] {
        var outcome = [T]()
        
        for (index: String, subJson: JSON) in json {
            outcome.append(_objectSerializer.deserialize(subJson))
        }
        
        return outcome
    }
}