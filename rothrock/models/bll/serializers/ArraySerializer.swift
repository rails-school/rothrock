//
//  ArraySerializer.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IArrayDeserializer<U>: IJSONDeserializer {
    typealias T = Array<U>
    
    public func deserialize(json: JSON) -> Array<U> {
        return Array<U>()
    }
}

internal class ArraySerializer<U, A: IJSONDeserializer where A.T == U>: IArrayDeserializer<U> {
    private var _objectSerializer: A
    
    init(objectSerializer: A) {
        self._objectSerializer = objectSerializer
    }
    
    override func deserialize(json: JSON) -> Array<U> {
        var outcome = [U]()
        
        for (index: String, subJson: JSON) in json {
            outcome.append(_objectSerializer.deserialize(subJson))
        }
        
        return outcome
    }
}