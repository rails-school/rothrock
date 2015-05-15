//
//  BLLFactory.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class BLLFactory {
    private static var _user: IUserBusiness?
    private static var _lesson: ILessonBusiness?
    private static var _venue: IVenueBusiness?
    private static var _preference: IPreferenceBusiness?
    
    public static var user: IUserBusiness {
        if let o = _user {
            return o
        } else {
            _user = UserBusiness(api: RailsSchoolAPIFactory.api, userDAO: DAOFactory.user)
            return self.user
        }
    }
    
    public static var lesson: ILessonBusiness {
        if let o = _lesson {
            return o
        } else {
            _lesson = LessonBusiness(api: RailsSchoolAPIFactory.api, userBusiness: user, venueBusiness: venue, preferenceBusiness: preference, lessonDAO: DAOFactory.lesson)
            return self.lesson
        }
    }
    
    public static var venue: IVenueBusiness {
        if let o = _venue {
            return o
        } else {
            _venue = VenueBusiness(api: RailsSchoolAPIFactory.api, venueDao: DAOFactory.venue)
            return self.venue
        }
    }
    
    public static var preference: IPreferenceBusiness {
        if let o = _preference {
            return o
        } else {
            _preference = PreferenceBusiness(prefDAO: DAOFactory.preference)
            return self.preference
        }
    }
}