//
//  LessonDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class LessonDAO: BaseDAO, ILessonDAO {
    
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
    
    func truncateTable() {
        var lessons = Lesson.allObjects()
        
        for l in lessons {
            delete(l)
        }
    }
}