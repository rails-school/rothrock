//
//  IPreferenceDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IPreferenceDAO {
    func getTwoHourNotificationPreference() -> TwoHourNotificationPreference?
    
    func setTwoHourNotificationPreference(value: TwoHourNotificationPreference)
    
    func getDayNotificationPreference() -> DayNotificationPreference?
    
    func setDayNotificationPreference(value: DayNotificationPreference)
    
    func getLessonAlertPreference() -> Bool?
    
    func setLessonAlertPreference(value: Bool)
}