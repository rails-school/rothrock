//
//  DAOFactory.swift
//  rothrock
//
//  Created by Adrien on 14/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class DAOFactory {
    private static var _user: IUserDAO?
    private static var _lesson: ILessonDAO?
    private static var _venue: IVenueDAO?
    private static var _preference: IPreferenceDAO?
    
    public static func provideUser() -> IUserDAO {
        if let o = _user {
            return o
        } else {
            _user = UserDAO(dal: RLMRealm.defaultRealm(), preferenceStorage: NSUserDefaults.standardUserDefaults())
            return _user!
        }
    }
    
    public static func provideLesson() -> ILessonDAO {
        if let o = _lesson {
            return o
        } else {
            _lesson = LessonDAO(dal: RLMRealm.defaultRealm())
            return _lesson!
        }
    }
    
    public static func provideVenue() -> IVenueDAO {
        if let o = _venue {
            return o
        } else {
            _venue = VenueDAO(dal: RLMRealm.defaultRealm())
            return _venue!
        }
    }
    
    public static func providePreference() -> IPreferenceDAO {
        if let o = _preference {
            return o
        } else {
            _preference = PreferenceDAO(preferenceStorage: NSUserDefaults.standardUserDefaults())
            return _preference!
        }
    }
}