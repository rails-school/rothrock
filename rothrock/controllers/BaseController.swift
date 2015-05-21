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
    public override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    public func publishError(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
        done()
    }
    
    public func fork() {
        SwiftEventBus.post(ProgressForkEvent.NAME)
    }
    
    public func done() {
        SwiftEventBus.post(ProgressDoneEvent.NAME)
    }
}