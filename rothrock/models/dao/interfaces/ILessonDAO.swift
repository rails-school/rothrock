//
//  ILessonDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol ILessonDAO {
    func exists(slug: String) -> Bool
    
    func find(slug: String) -> Lesson?
    
    func save(lesson: Lesson)
    
    func truncateTable()
}
