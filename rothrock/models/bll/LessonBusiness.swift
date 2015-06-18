//
//  LessonBusiness.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class LessonBusiness: BaseBusiness, ILessonBusiness {
    private static let COOLDOWN_SEC = 5 * 60
    
    private var _userBusiness: IUserBusiness
    private var _venueBusiness: IVenueBusiness
    private var _preferenceBusiness: IPreferenceBusiness
    private var _lessonDAO: ILessonDAO
    
    internal init(api: IRailsSchoolAPI, userBusiness: IUserBusiness, venueBusiness: IVenueBusiness, preferenceBusiness: IPreferenceBusiness, lessonDAO: ILessonDAO) {
        
        self._userBusiness = userBusiness
        self._venueBusiness = venueBusiness
        self._preferenceBusiness = preferenceBusiness
        self._lessonDAO = lessonDAO
        
        super.init(api: api)
    }
    
    private func _shouldBeNotified(periodMilli: Int, lesson: Lesson, hours: Int) -> Bool {
        var startTime: NSDate = NSDate.fromString(lesson.startTime!)!
        var now = NSDate()
        var isInCountdownInterval = now.isInInterval(startTime.dateBySubtractingHours(hours), end: startTime)
        var isFirstNotification = now.isInInterval(startTime.dateBySubtractingHours(hours), end: startTime.dateBySubtractingHours(hours).dateByAddingSeconds(periodMilli * 1000))
        
        return isInCountdownInterval && isFirstNotification
    }
    
    private func _sortFutureSchoolClassesByDateAsDictionary(slugs: [String], cursor: Int, outcome: [NSDictionary], success: ([NSDictionary]?) -> Void, failure: (String) -> Void) {
        if cursor == slugs.count {
            success(outcome)
        } else {
            getSchoolClassTupleAsDictionary(
                slugs[cursor],
                success: { dict in
                    var o = outcome
                    
                    o.append(dict!)
                    self._sortFutureSchoolClassesByDateAsDictionary(slugs, cursor: cursor + 1, outcome: o, success: success, failure: failure)
                },
                failure: failure
            )
        }
    }
    
    func getLessonURL(lesson: Lesson) -> String {
        return "api_endpoint".localized + "/l/\(lesson.slug)"
    }
    
    func sortFutureSlugsByDate(success: ([String]?) -> Void, failure: (String) -> Void) {
        var callback = BLLCallback(base: self, success: { success($1) }, failure: failure)
        
        if _userBusiness.isSignedIn() {
            api.getFutureLessonSlugs(_userBusiness.getCurrentUserSchoolId()!, callback: callback)
        } else {
            api.getFutureLessonSlugs(callback)
        }
    }
    
    func sortFutureSchoolClassesByDateAsDictionary(success: ([NSDictionary]?) -> Void, failure: (String) -> Void) {
        sortFutureSlugsByDate(
            { slugs in
                if slugs == nil {
                    success(nil)
                } else {
                    self._sortFutureSchoolClassesByDateAsDictionary(
                        slugs!,
                        cursor: 0,
                        outcome: [NSDictionary](),
                        success: success,
                        failure: failure
                    )
                }
            },
            failure: failure
        )
    }
    
    func get(lessonSlug: String, success: (Lesson?) -> Void, failure: (String) -> Void) {
        if _lessonDAO.exists(lessonSlug) {
            let l = _lessonDAO.find(lessonSlug)
            
            success(l)
            
            if NSDate().dateBySubtractingSeconds(l!.updateDate!.second()).second() >= LessonBusiness.COOLDOWN_SEC {
                api.getLesson(lessonSlug, callback: BLLCallback(base: self, success: { self._lessonDAO.save($1!) }, failure: failure))
            }
        } else {
            api.getLesson(lessonSlug, callback: BLLCallback(base: self, success: { success($1); self._lessonDAO.save($1!) }, failure: failure))
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
    
    func getSchoolClassTupleAsDictionary(lessonSlug: String, success: (NSDictionary?) -> Void, failure: (String) -> Void) {
        getSchoolClassTuple(
            lessonSlug,
            success: { schoolClass, teacher, venue in
                var startDate: NSDate = NSDate.fromString(schoolClass!.lesson!.startTime!)!
                var endDate: NSDate = NSDate.fromString(schoolClass!.lesson!.endTime!)!
                
                // Compute hour field
                var hourField = ""
                var startHour = startDate.hour()
                var startMinute = startDate.minute()
                var endHour = endDate.hour()
                var endMinute = endDate.minute()
                
                if startHour > 12 {
                    hourField += "\(startHour - 12)"
                } else {
                    hourField += "\(startHour)"
                }
                
                if startMinute > 0 {
                    hourField += ":\(startMinute)"
                }
                
                hourField += " to "
                
                if endHour >= 12 {
                    if endHour > 12 {
                        hourField += "\(endHour - 12)"
                    } else {
                        hourField += "12"
                    }
                    
                    if endMinute > 0 {
                        hourField += ":\(endMinute)"
                    }
                    
                    hourField += " PM"
                } else {
                    hourField += "\(endHour)"
                    if endMinute > 0 {
                        hourField += ":\(endMinute)"
                    }
                    hourField += " AM"
                }
                
                hourField += " \(NSTimeZone.localTimeZone().abbreviation!)"
                
                var dict: NSMutableDictionary = [
                    "lesson": [
                        "slug": schoolClass!.lesson!.slug,
                        "title": schoolClass!.lesson!.title!,
                        "summary": schoolClass!.lesson!.summary!,
                        "date": "\(startDate.shortMonth()) \(startDate.day())",
                        "hour": "\(hourField)",
                        "countdown": startDate.userFriendly()
                    ],
                    "teacher": [
                        "name": teacher!.displayedName
                    ],
                    "venue": [
                        "name": venue!.name!
                    ],
                    "attendees": "\(schoolClass!.students!.count)"
                ]
                
                self._userBusiness.isCurrentUserAttendingTo(
                    schoolClass!.lesson!.slug,
                    isAttending: { isAttending in
                        dict.setObject(isAttending, forKey: "isAttending")
                        success(dict)
                    },
                    needToSignIn: {
                        dict.setObject(false, forKey: "isAttending")
                        success(dict)
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
                base: self,
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
        let failure: (String) -> Void = {
            NSLog("%@: %@", NSStringFromClass(LessonBusiness.self), $0)
        }
        var callback = BLLCallback(base: self, success: { success($1) }, failure: failure)
        
        if _userBusiness.isSignedIn() {
            api.getUpcomingLesson(_userBusiness.getCurrentUserSchoolId()!, callback: callback)
        } else {
            api.getUpcomingLesson(callback)
        }
    }
    
    func engineAlarms(periodMilli: Int, twoHourAlarm: (Lesson?) -> Void, dayAlarm: (Lesson?) -> Void) {
        getUpcoming({
            if let lesson = $0 { // Only if upcoming lesson
                let failure: (String) -> Void = { NSLog("%@: %@", NSStringFromClass(LessonBusiness.self), $0) }
                
                if self._shouldBeNotified(periodMilli, lesson: lesson, hours: 2) {
                    let pref = self._preferenceBusiness.getTwoHourReminderPreference()
                    
                    switch (pref!) {
                    case .Always:
                        twoHourAlarm(lesson)
                    case .IfAttending:
                        self._userBusiness.isCurrentUserAttendingTo(
                            lesson.slug,
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
                    default:
                        break
                    }
                }
                
                if self._shouldBeNotified(periodMilli, lesson: lesson, hours: 24) {
                    let pref = self._preferenceBusiness.getDayReminderPreference()
                    
                    switch (pref!) {
                    case .Always:
                        dayAlarm(lesson)
                    case .IfAttending:
                        self._userBusiness.isCurrentUserAttendingTo(
                            lesson.slug,
                            isAttending: {
                                if $0 {
                                    dayAlarm(lesson)
                                }
                            },
                            needToSignIn: {
                                
                            },
                            failure: failure
                        )
                    default:
                        break
                    }
                }
            }
        })
    }
}