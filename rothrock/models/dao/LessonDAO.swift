//
//  LessonDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class LessonDAO: BaseDAO, ILessonDAO {
    private static let LATEST_CLEAN_KEY = "latest_clean"
    
    private var _keyValueDAL: NSUserDefaults
    
    init(dal: RLMRealm, keyValueStorage: NSUserDefaults) {
        self._keyValueDAL = keyValueStorage
        
        super.init(dal: dal)
    }
    
    func exists(slug: String) -> Bool {
        if let l = find(slug) {
            return true
        } else {
            return false
        }
    }
    
    func find(slug: String) -> Lesson? {
        let pred = NSPredicate(format: "slug = %@", slug)
        
        return Lesson.objectsInRealm(dal, withPredicate: pred).firstObject() as! Lesson?
    }
    
    func save(lesson: Lesson) {
        dal.beginWriteTransaction()
        lesson.updateDate = NSDate()
        Lesson.createOrUpdateInRealm(dal, withValue: lesson)
        dal.commitWriteTransaction()
    }
    
    internal func delete(lesson: Lesson) {
        dal.beginWriteTransaction()
        dal.deleteObject(lesson)
        dal.commitWriteTransaction()
    }
    
    func getLatestClean() -> NSDate? {
        var date = _keyValueDAL.objectForKey(LessonDAO.LATEST_CLEAN_KEY) as? String
        
        if let d = date {
            return NSDate.fromString(d)
        } else {
            return nil
        }
    }
    
    func truncateTable() {
        var lessons = Lesson.allObjects()
        
        for i in 0..<lessons.count {
            delete(lessons.objectAtIndex(i) as! Lesson)
        }
        
        _keyValueDAL.setObject(NSDate().toString(), forKey: LessonDAO.LATEST_CLEAN_KEY)
    }
}