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

public class SubController: NSObject {
    private var _webView: UIWebView
    private var _parentController: UIViewController
    
    public init(parentController: UIViewController, webView: UIWebView) {
        self._parentController = parentController
        self._webView = webView
    }
    
    public var parentController: UIViewController {
        return _parentController
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
    
    public func inform(message: String) {
        SwiftEventBus.post(InformationEvent.NAME, sender: InformationEvent(message: message))
    }
    
    public func confirm(message: String) {
        SwiftEventBus.post(ConfirmationEvent.NAME, sender: ConfirmationEvent(message: message))
    }
    
    public func alert(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
    }
    
    public func publishError(message: String) {
        done()
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
    }
    
    public func onStart() {
        
    }
    
    public func onResume() {
        
    }
    
    public func onPause() {
        
    }
}