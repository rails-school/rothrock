//
//  SchoolClassSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class SchoolClassSeriazlier<D1: IJSONDeserializer, D2: IJSONDeserializer where D1.T == Lesson, D2.T == User>: IJSONDeserializer {
    typealias T = SchoolClass
    
    private var _lessonDeserializer: D1
    private var _userDeserializer: D2
    
    init(lessonDeserializer: D1, userDeserializer: D2) {
        self._lessonDeserializer = lessonDeserializer
        self._userDeserializer = userDeserializer
    }
    
    func deserialize(json: JSON) -> SchoolClass {
        var outcome = SchoolClass()
        
        outcome.lesson = _lessonDeserializer.deserialize(json)
        outcome.students = [User]()
        for (index: String, subJson: JSON) in json["students"] {
            outcome.students?.append(_userDeserializer.deserialize(subJson))
        }
        
        return outcome
    }
}