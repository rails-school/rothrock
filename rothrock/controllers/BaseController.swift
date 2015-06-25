//
//  BaseController.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

public class BaseController: UIViewController {    
    public func fork() {
        SwiftEventBus.post(ProgressForkEvent.NAME)
    }
    
    public func done() {
        SwiftEventBus.post(ProgressDoneEvent.NAME)
    }
    
    public func publishError(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
        done()
    }
    
    public func inform(message: String) {
        SwiftEventBus.post(InformationEvent.NAME, sender: InformationEvent(message: message))
    }
    
    public func confirm(message: String) {
        SwiftEventBus.post(ConfirmationEvent.NAME, sender: ConfirmationEvent(message: message))
    }
    
    public func alert(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
    }
}