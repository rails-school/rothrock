//
//  SchoolClassSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ISchoolClassDeserializer: IJSONDeserializer {
    typealias T = SchoolClass
    
    public func deserialize(json: JSON) -> SchoolClass {
        return SchoolClass()
    }
}

internal class SchoolClassSeriazlier: ISchoolClassDeserializer {
    private var _lessonDeserializer: ILessonDeserializer
    private var _userArrayDeserializer: IArrayDeserializer<User>
    
    init(lessonDeserializer: ILessonDeserializer, userArrayDeserializer: IArrayDeserializer<User>) {
        self._lessonDeserializer = lessonDeserializer
        self._userArrayDeserializer = userArrayDeserializer
    }
    
    override func deserialize(json: JSON) -> SchoolClass {
        var outcome = SchoolClass()
        
        outcome.lesson = _lessonDeserializer.deserialize(json)
        outcome.students = _userArrayDeserializer.deserialize(json["students"])
        
        return outcome
    }
}