//
//  AlarmManager.swift
//  rothrock
//
//  Created by Adrien on 22/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

internal class AlarmManager {
    private var _application: UIApplication
    
    init(application: UIApplication) {
        self._application = application
        
        BusinessFactory
            .provideLesson()
            .engineAlarms(
                30 * 60 * 1000, // Every half hour
                twoHourAlarm: { lesson in
                    self._scheduleAlarm(lesson, hours: 2, title: "reminder_two_hours".localized)
                },
                dayAlarm: { lesson in
                    self._scheduleAlarm(lesson, hours: 24, title: "reminder_next_day".localized)
                }
        )
    }
    
    private func _scheduleAlarm(lesson: Lesson?, hours: Int, title: String) {
        var fireDate = NSDate.fromString(lesson!.startTime!)!.dateBySubtractingHours(hours)
        var notification = UILocalNotification()
        
        for o in _application.scheduledLocalNotifications {
            var n = o as! UILocalNotification
            if n.fireDate == fireDate { // Cancel existing similar alarm, then schedule it again
                _application.cancelLocalNotification(n)
                break
            }
        }
        
        notification.fireDate = fireDate
        notification.alertTitle = title
        notification.alertBody = lesson!.title
        notification.soundName = UILocalNotificationDefaultSoundName
        _application.scheduleLocalNotification(notification)
    }
}