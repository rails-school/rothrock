//
//  PresentSingleClassController.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class PresentSingleClassControllerEvent {
    public static let NAME = "PresentSingleClassControllerEvent"
    
    private var _slug: String
    
    public var slug: String {
        return _slug
    }
    
    public init(slug: String) {
        self._slug = slug
    }    
}