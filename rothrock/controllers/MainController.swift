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

public class MainController: BaseController {
    @IBOutlet weak var _webView: UIWebView!
    
    private var _classListController: SubController?
    private var _settingsController: SubController?
    private var _singleClassController: UIViewController?

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
            
            
            
            SwiftEventBus.onMainThread(self, name: PresentSingleClassControllerEvent.NAME) { notif in
                var e = notif.object as! PresentSingleClassControllerEvent
                
                if self._singleClassController == nil {
                    self._singleClassController = self.storyboard!.instantiateViewControllerWithIdentifier("SingleClassController") as! UIViewController
                }
                
                bus.post("ManualPausingClassListController")
                self._classListController!.onPause()
                self.presentViewController(self._singleClassController!, animated: true) {
                    SwiftEventBus.post(SingleClassInitEvent.NAME, sender: SingleClassInitEvent(slug: e.slug))
                }
            }
            
            SwiftEventBus.onMainThread(self, name: ClosedSingleClassControllerEvent.NAME) { _ in
                bus.post("ManualResumingClassListController")
                self._classListController!.onResume()
            }
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("main", withExtension: "html")!))
    }
}

