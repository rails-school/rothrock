//
//  PreferenceDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class PreferenceDAO: IPreferenceDAO {
    private static let TWO_HOUR_NOTIFICATION_KEY = "two_hour_notification",
        DAY_NOTIFICATION_KEY = "day_notification"
    
    private var _dal: NSUserDefaults
    
    init() {
        self._dal = NSUserDefaults.standardUserDefaults()
    }
    
    func getTwoHourNotificationPreference() -> TwoHourNotificationPreference? {
        return TwoHourNotificationPreference(rawValue: _dal.integerForKey(PreferenceDAO.TWO_HOUR_NOTIFICATION_KEY))
    }
    
    func setTwoHourNotificationPreference(value: TwoHourNotificationPreference) {
        _dal.setInteger(value.rawValue as Int, forKey: PreferenceDAO.TWO_HOUR_NOTIFICATION_KEY)
    }
    
    func getDayNotificationPreference() -> DayNotificationPreference? {
        return DayNotificationPreference(rawValue: _dal.integerForKey(PreferenceDAO.DAY_NOTIFICATION_KEY))
    }
    
    func setDayNotificationPreference(value: DayNotificationPreference) {
        _dal.setInteger(value.rawValue, forKey: PreferenceDAO.DAY_NOTIFICATION_KEY)
    }
}