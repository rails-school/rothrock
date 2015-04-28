//
//  LessonSerializer.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

internal class LessonSerializer: IJSONDeserializer {
    typealias DeserializedType = Lesson
    
    func deserialize(json: JSON) -> Lesson {
        var outcome = Lesson()
        
        outcome.id = json["id"].intValue
        outcome.slug = json["slug"].stringValue
        outcome.title = json["title"].stringValue
        outcome.summary = json["summary"].stringValue
        outcome.lessonDescription = json["description"].stringValue
        outcome.startTime = json["start_time"].stringValue
        outcome.endTime = json["end_time"].stringValue
        outcome.teacherId = json["teacher_id"].intValue
        outcome.venueId = json["venue_id"].intValue
        
        return outcome
    }
}