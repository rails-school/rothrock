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
        
        return Lesson.objectsInRealm(getDAL(), withPredicate: pred).firstObject() as! Lesson?
    }
    
    func save(lesson: Lesson) {
        getDAL().beginWriteTransaction()
        lesson.updateDate = NSDate()
        Lesson.createOrUpdateInRealm(getDAL(), withObject: lesson)
        getDAL().commitWriteTransaction()
    }
}