//
//  ClassDetailsInitEvent.swift
//  rothrock
//
//  Created by Adrien on 18/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class ClassDetailsInitEvent {
    public static let NAME = "ClassDetailsInitEvent"
    
    private var _lessonSlug: String
    
    public var lessonSlug: String {
        return _lessonSlug
    }
    
    public init(lessonSlug: String) {
        self._lessonSlug = lessonSlug
    }
}