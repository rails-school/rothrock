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
    
    private static var _lesson: ILessonDeserializer?
    private static var _user: IUserDeserializer?
    private static var _venue: IVenueDeserializer?
    private static var _schoolClass: ISchoolClassDeserializer?
    
    public static func provideBool() -> IBoolDeserializer {
        if let o = _bool {
            return o
        } else {
            _bool = BoolSerializer()
            return _bool!
        }
    }
    
    public static func provideString() -> IStringDeserializer {
        if let o = _string {
            return o
        } else {
            _string = StringSerializer()
            return _string!
        }
    }
    
    public static func provideLesson() -> ILessonDeserializer {
        if let o = _lesson {
            return o
        } else {
            _lesson = LessonSerializer()
            return _lesson!
        }
    }
    
    public static func provideUser() -> IUserDeserializer {
        if let o = _user {
            return o
        } else {
            _user = UserSerializer()
            return _user!
        }
    }
    
    public static func provideVenue() -> IVenueDeserializer {
        if let o = _venue {
            return o
        } else {
            _venue = VenueSerializer()
            return _venue!
        }
    }
    
    public static func provideSchoolClass() -> ISchoolClassDeserializer {
        if let o = _schoolClass {
            return o
        } else {
            _schoolClass = SchoolClassSerializer(lessonDeserializer: provideLesson(), userArrayDeserializer: ArraySerializer(objectSerializer: provideUser()))
            return _schoolClass!
        }
    }
}