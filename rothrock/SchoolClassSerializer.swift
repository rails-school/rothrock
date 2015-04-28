//
//  SchoolClassSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class SchoolClassSeriazlier<D1: IJSONDeserializer, D2: IJSONDeserializer where D1.DeserializedType == Lesson, D2.DeserializedType == [User]>: IJSONDeserializer {
    typealias T = SchoolClass
    
    private var _lessonDeserializer: D1
    private var _userArrayDeserializer: D2
    
    init(lessonDeserializer: D1, userArrayDeserializer: D2) {
        self._lessonDeserializer = lessonDeserializer
        self._userArrayDeserializer = userArrayDeserializer
    }
    
    func deserialize(json: JSON) -> SchoolClass {
        var outcome = SchoolClass()
        
        outcome.lesson = _lessonDeserializer.deserialize(json)
        outcome.students = _userArrayDeserializer.deserialize(json["students"])
        
        return outcome
    }
}