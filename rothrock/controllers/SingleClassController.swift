//
//  SingleClassController.swift
//  Rails School
//
//  Created by Adrien on 23/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import Caravel
import SwiftEventBus

internal class SingleClassController: UIViewController {
    
    @IBOutlet weak var _webView: UIWebView!
    
    private var _slug: String?
    private var _bus: Caravel?
    
    private func _fork() {
        SwiftEventBus.post(ProgressForkEvent.NAME)
    }
    
    private func _done() {
        SwiftEventBus.post(ProgressDoneEvent.NAME)
    }
    
    private func _publishError(message: String) {
        _done()
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
    }
    
    private func _sendClass() {
        BusinessFactory
            .provideLesson()
            .getSchoolClassTupleAsDictionary(
                _slug!,
                success: { dict in
                    self._bus!.post("ReceiveClass", aDictionary: dict!)
                },
                failure: { self._publishError($0) }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(self, name: SingleClassInitEvent.NAME) { notif in
            var e = notif.object as! SingleClassInitEvent
            
            self._slug = e.slug
            if self._bus != nil { // JS bus ready before that event, notify JS then
                self._sendClass()
            }
        }
        
        Caravel.get("SingleClassController", webView: _webView).whenReady() { bus in
            self._bus = bus
            if self._slug != nil { // Slug has been received, notify JS then
                self._sendClass()
            }
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("main_single_class", withExtension: "html")!))
    }
}
