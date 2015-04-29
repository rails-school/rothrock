//
//  SerializerFactory.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class SerializerFactory {
    private static var _checkCredentialsRequest: ICheckCredentialsRequestSerializer?
    private static var _lesson: ILessonDeserializer?
    
    public static var checkCredentialsRequest: ICheckCredentialsRequestSerializer {
        if let o = _checkCredentialsRequest {
            return o
        } else {
            _checkCredentialsRequest = CheckCredentialsRequestSerializer()
            return self.checkCredentialsRequest
        }
    }
    
    public static var lesson: ILessonDeserializer {
        if let o = _lesson {
            return o
        } else {
            _lesson = LessonSerializer()
            return self.lesson
        }
    }
}