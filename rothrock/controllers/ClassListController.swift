//
//  ViewController.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit
import SwiftEventBus

public class ClassListController: UIViewController {
    @IBOutlet weak var _webView: UIWebView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Caravel.getDefault(_webView).whenReady() { bus in
            bus.register(ProgressDoneEvent.NAME) { name, data in
                SwiftEventBus.post(ProgressDoneEvent.NAME)
            }
            
            SwiftEventBus.post(ProgressForkEvent.NAME)
            BusinessFactory
                .provideLesson()
                .sortFutureTuplesByDate(
                    { tuples in
                        bus.post("DisplayClassList", anArray: tuples!)
                    },
                    failure: { self.publishError($0) }
                )
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("class_list", withExtension: "html")!))
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func publishError(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
    }
}

