//
//  PreferenceDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class PreferenceDAO: IPreferenceDAO {
    private static let TWO_HOUR_NOTIFICATION_KEY = "preferences_two_hour_notification",
        DAY_NOTIFICATION_KEY = "preferences_day_notification",
        LESSON_ALERT_KEY = "preferences_lesson_alert"
    
    private var _dal: NSUserDefaults
    
    init(preferenceStorage: NSUserDefaults) {
        self._dal = preferenceStorage
    }
    
    func getTwoHourNotificationPreference() -> TwoHourNotificationPreference? {
        if let o: AnyObject = _dal.objectForKey(PreferenceDAO.TWO_HOUR_NOTIFICATION_KEY) {
            return TwoHourNotificationPreference(rawValue: o as! Int)
        } else {
            return .IfAttending
        }
    }
    
    func setTwoHourNotificationPreference(value: TwoHourNotificationPreference) {
        _dal.setInteger(value.rawValue as Int, forKey: PreferenceDAO.TWO_HOUR_NOTIFICATION_KEY)
    }
    
    func getDayNotificationPreference() -> DayNotificationPreference? {
        if let o : AnyObject = _dal.objectForKey(PreferenceDAO.DAY_NOTIFICATION_KEY) {
            return DayNotificationPreference(rawValue: o as! Int)
        } else {
            return .Always
        }
    }
    
    func setDayNotificationPreference(value: DayNotificationPreference) {
        _dal.setInteger(value.rawValue, forKey: PreferenceDAO.DAY_NOTIFICATION_KEY)
    }
    
    func getLessonAlertPreference() -> Bool {
        if let o: AnyObject = _dal.objectForKey(PreferenceDAO.LESSON_ALERT_KEY) {
            return o as! Bool
        } else {
            return true
        }
    }
    
    func setLessonAlertPreference(value: Bool) {
        _dal.setBool(value, forKey: PreferenceDAO.LESSON_ALERT_KEY)
    }
}