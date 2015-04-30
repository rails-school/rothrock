//
//  LessonBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class LessonBusiness: BaseBusiness, ILessonBusiness {
    private static var COOLDOWN_SEC = 5 * 60
    
    private var _userBusiness: IUserBusiness
    private var _venueBusiness: IVenueBusiness
    private var _preferenceBusiness: IPreferenceBusiness
    private var _lessonDAO: ILessonDAO
    
    internal init(api: IRailsSchoolAPI, userBusiness: IUserBusiness, venueBusiness: IVenueBusiness, preferenceBusiness: IPreferenceBusiness, lessonDao: ILessonDAO) {
        
        self._userBusiness = userBusiness
        self._venueBusiness = venueBusiness
        self._preferenceBusiness = preferenceBusiness
        self._lessonDAO = lessonDao
        
        super.init(api: api)
    }
    
    private func _isWithinInterval(lesson: Lesson, hours: Int) -> Bool {
        var startDate = NSDate().dateBySubtractingHours(hours)
        
        return lesson.updateDate!.isLaterThanOrEqualTo(startDate) && lesson.updateDate!.isEarlierThanOrEqualTo(NSDate())
    }
    
    func sortFutureSlugsByDate(success: ([String]?) -> Void, failure: (String) -> Void) {
        api.getFutureLessonSlugs(BLLCallback(success: { success($1) }, failure: failure))
    }
    
    func get(lessonSlug: String, success: (Lesson?) -> Void, failure: (String) -> Void) {
        if _lessonDAO.exists(lessonSlug) {
            let l = _lessonDAO.find(lessonSlug)
            
            success(l)
            
            if (NSDate().dateBySubtractingSeconds(l!.updateDate!.second()).second() >= LessonBusiness.COOLDOWN_SEC) {
                api.getLesson(lessonSlug, callback: BLLCallback(success: { self._lessonDAO.save($1!) }, failure: failure))
            }
        } else {
            api.getLesson(lessonSlug, callback: BLLCallback(success: { success($1); self._lessonDAO.save($1!) }, failure: failure))
        }
    }
    
    func getTuple(lessongSlug: String, success: (Lesson?, User?, Venue?) -> Void, failure: (String) -> Void) {
        get(
            lessongSlug,
            success: { lesson in
                self._userBusiness.get(
                    lesson!.teacherId,
                    success: { teacher in
                        self._venueBusiness.get(
                            lesson!.venueId,
                            success: { venue in
                                success(lesson, teacher, venue)
                            },
                            failure: failure
                        )
                    },
                    failure: failure
                )
            },
            failure: failure
        )
    }
    
    func getSchoolClassTuple(lessonSlug: String, success: (SchoolClass?, User?, Venue?) -> Void, failure: (String) -> Void) {
        api.getSchoolClass(
            lessonSlug,
            callback: BLLCallback<SchoolClass>(
                success: { (response, schoolClass) in
                    self._userBusiness.get(
                        schoolClass!.lesson!.teacherId,
                        success: { teacher in
                            self._venueBusiness.get(
                                schoolClass!.lesson!.venueId,
                                success: { venue in
                                    success(schoolClass, teacher, venue)
                                },
                                failure: failure
                            )
                        },
                        failure: failure
                    )
                },
                failure: failure
            )
        )
    }
    
    func getUpcoming(success: (Lesson?) -> Void) {
        let failure: (String) -> Void = { NSLog(NSStringFromClass(LessonBusiness.self), $0) }
        
        api.getUpcomingLesson(BLLCallback(success: { success($1) }, failure: failure))
    }
    
    func engineAlarms(twoHourAlarm: (Lesson?) -> Void, dayAlarm: (Lesson?) -> Void) {
        getUpcoming({
            if let lesson = $0 { // Only if upcoming lesson
                let failure: (String) -> Void = { NSLog(NSStringFromClass(LessonBusiness.self), $0) }
                
                if self._isWithinInterval(lesson, hours: 2) {
                    let pref = self._preferenceBusiness.getTwoHourReminderPreference()
                    
                    switch (pref) {
                    case .Always:
                        twoHourAlarm(lesson)
                    case .IfAttending:
                        self._userBusiness.isCurrentUserAttendingTo(
                            lesson.slug!,
                            isAttending: {
                                if $0 {
                                    twoHourAlarm(lesson)
                                }
                            },
                            needToSignIn: {
                                // User not signed in, ignore preference
                            },
                            failure: failure
                        )
                    }
                }
                
                if self._isWithinInterval(lesson, hours: 24) {
                    let pref = self._preferenceBusiness.getDayReminderPreference()
                    
                    switch (pref) {
                    case .Always:
                        dayAlarm(lesson)
                    case .IfAttending:
                        self._userBusiness.isCurrentUserAttendingTo(
                            lesson.slug!,
                            isAttending: {
                                if $0 {
                                    dayAlarm(lesson)
                                }
                            },
                            needToSignIn: {
                                
                            },
                            failure: failure
                        )
                    }
                }
            }
        })
    }
}