//
//  SerializerFactory.swift
//  rothrock
//
//  Created by Adrien on 28/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class SerializerFactory {
    private static var _bool: IBoolDeserializer?
    private static var _string: IStringDeserializer?
    
    private static var _checkCredentialsRequest: ICheckCredentialsRequestSerializer?
    private static var _lesson: ILessonDeserializer?
    private static var _user: IUserDeserializer?
    private static var _venue: IVenueDeserializer?
    private static var _schoolClass: ISchoolClassDeserializer?
    
    public static var bool: IBoolDeserializer {
        if let o = _bool {
            return o
        } else {
            _bool = BoolSerializer()
            return self.bool
        }
    }
    
    public static var string: IStringDeserializer {
        if let o = _string {
            return o
        } else {
            _string = StringSerializer()
            return self.string
        }
    }
    
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
    
    public static var venue: IVenueDeserializer {
        if let o = _venue {
            return o
        } else {
            _venue = VenueSerializer()
            return self.venue
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