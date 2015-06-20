//
//  ViewController.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit
import SwiftEventBus
import EventKit
import MessageUI
import Caravel

public class MainController: UIViewController {
    @IBOutlet weak var _webView: UIWebView!
    
    private var _classListController: BaseController?
    private var _settingsController: BaseController?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Caravel.getDefault(_webView).whenReady() { bus in
            bus.register(ProgressDoneEvent.NAME) { name, data in
                self.done()
            }
            
            bus.register(ProgressForkEvent.NAME) { name, data in
                self.fork()
            }
            
            bus.register("StartingClassListController") { _, _ in
                self._classListController = ClassListController(parentController: self, webView: self._webView)
                self._classListController!.onStart()
            }
            bus.register("ResumingClassListController") { _, _ in self._classListController!.onResume() }
            bus.register("PausingClassListController") { _, _ in self._classListController!.onPause() }
            
            bus.register("StartingSettingsController") { name, data in
                self._settingsController = SettingsController(parentController: self, webView: self._webView)
                self._settingsController!.onStart()
            }
            bus.register("ResumingSettingsController") { _, _ in self._settingsController!.onResume() }
            bus.register("PausingSettingsController")  { _, _ in self._settingsController!.onPause() }
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("main", withExtension: "html")!))
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

