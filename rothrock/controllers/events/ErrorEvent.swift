//
//  ErrorEvent.swift
//  rothrock
//
//  Created by Adrien on 18/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class ErrorEvent {
    public static let NAME = "ErrorEvent"
    
    private var _message: String
    
    public var message: String {
        return _message
    }
    
    public init(message: String) {
        self._message = message
    }
}