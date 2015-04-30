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
}