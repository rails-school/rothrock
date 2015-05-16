//
//  PreferenceBusiness.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class PreferenceBusiness: IPreferenceBusiness {
    private var _prefDAO: IPreferenceDAO
    
    internal init(prefDAO: IPreferenceDAO) {
        self._prefDAO = prefDAO
    }
    
    func updateTwoHourReminderPreference(preference: TwoHourNotificationPreference) {
        _prefDAO.setTwoHourNotificationPreference(preference)
    }
    
    func getTwoHourReminderPreference() -> TwoHourNotificationPreference? {
        return _prefDAO.getTwoHourNotificationPreference()
    }
    
    func updateDayReminderPreference(preference: DayNotificationPreference) {
        _prefDAO.setDayNotificationPreference(preference)
    }
    
    func getDayReminderPreference() -> DayNotificationPreference? {
        return _prefDAO.getDayNotificationPreference()
    }
    
    func updateLessonAlertPreference(value: Bool) {
        _prefDAO.setLessonAlertPreference(value)
    }
    
    func getLessonAlertPreference() -> Bool {
        return _prefDAO.getLessonAlertPreference()
    }
}