//
//  BLLFactory.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class BusinessFactory {
    private static var _user: IUserBusiness?
    private static var _lesson: ILessonBusiness?
    private static var _venue: IVenueBusiness?
    private static var _preference: IPreferenceBusiness?
    
    public static func provideUser() -> IUserBusiness {
        if let o = _user {
            return o
        } else {
            _user = UserBusiness(api: RailsSchoolAPIFactory.provideAPI(), userDAO: DAOFactory.provideUser())
            return _user!
        }
    }
    
    public static func provideLesson() -> ILessonBusiness {
        if let o = _lesson {
            return o
        } else {
            _lesson = LessonBusiness(api: RailsSchoolAPIFactory.provideAPI(), userBusiness: provideUser(), venueBusiness: provideVenue(), preferenceBusiness: providePreference(), lessonDAO: DAOFactory.provideLesson())
            return _lesson!
        }
    }
    
    public static func provideVenue() -> IVenueBusiness {
        if let o = _venue {
            return o
        } else {
            _venue = VenueBusiness(api: RailsSchoolAPIFactory.provideAPI(), venueDao: DAOFactory.provideVenue())
            return _venue!
        }
    }
    
    public static func providePreference() -> IPreferenceBusiness {
        if let o = _preference {
            return o
        } else {
            _preference = PreferenceBusiness(prefDAO: DAOFactory.providePreference())
            return _preference!
        }
    }
}