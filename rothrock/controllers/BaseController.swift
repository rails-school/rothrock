//
//  BaseController.swift
//  rothrock
//
//  Created by Adrien on 16/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

public class BaseController: UIViewController {
 
    public func publishError(message: String) {
        SwiftEventBus.post(ControllerEvents.ErrorEvent.rawValue, sender: message)
    }
    
    public func fork() {
        SwiftEventBus.post(ControllerEvents.ProgressForkEvent.rawValue)
    }
    
    public func done() {
        SwiftEventBus.post(ControllerEvents.ProgressDoneEvent.rawValue)
    }
}