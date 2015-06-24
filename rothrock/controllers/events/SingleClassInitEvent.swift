//
//  SingleClassInitEvent.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class SingleClassInitEvent {
    public static let NAME = "SingleClassInitEvent"
    
    private var _slug: String
    
    public var slug: String {
        return _slug
    }
    
    public init(slug: String) {
        self._slug = slug
    }
}