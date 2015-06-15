//
//  BaseController.swift
//  rothrock
//
//  Created by Adrien on 15/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

public class BaseController {
    private var _webView: UIWebView
    
    public init(webView: UIWebView) {
        self._webView = webView
    }
    
    public var webView: UIWebView {
        return _webView
    }
    
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
    
    public func onStart() {
        
    }
    
    public func onResume() {
        
    }
    
    public func onPause() {
        
    }
}