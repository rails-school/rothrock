//
//  ControllerEvents.swift
//  rothrock
//
//  Created by Adrien on 16/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public enum ControllerEvents: String {
    case ProgressForkEvent = "ProgressForkEvent",
        ProgressDoneEvent = "ProgressDoneEvent"
    
    case ErrorEvent = "ErrorEvent",
        ConfirmationEvent = "ConfirmationEvent",
        InformationEvent = "InformationEvent"
}