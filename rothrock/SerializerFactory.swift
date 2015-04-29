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
    private static var _user: IUserDeserializer?
    private static var _schoolClass: ISchoolClassDeserializer?
    
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
    
    public static var user: IUserDeserializer {
        if let o = _user {
            return o
        } else {
            _user = UserSerializer()
            return self.user
        }
    }
    
    public static var schoolClass: ISchoolClassDeserializer {
        if let o = _schoolClass {
            return o
        } else {
            _schoolClass = SchoolClassSerializer(lessonDeserializer: lesson, userArrayDeserializer: ArraySerializer(objectSerializer: user))
            return self.schoolClass
        }
    }
}