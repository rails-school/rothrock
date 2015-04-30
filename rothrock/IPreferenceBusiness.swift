//
//  IPreferenceBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IPreferenceBusiness {
    func updateTwoHourReminderPreference(preference: TwoHourNotificationPreference)
    
    func getTwoHourReminderPreference() -> TwoHourNotificationPreference
    
    func updateDayReminderPreference(preference: DayNotificationPreference)
    
    func getDayReminderPreference() -> DayNotificationPreference
}