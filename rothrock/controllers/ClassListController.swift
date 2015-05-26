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
    
    private func _setClassListContent(callback: ([NSDictionary]?) -> Void) {
        BusinessFactory
            .provideLesson()
            .sortFutureTuplesByDate(
                callback,
                failure: { self.publishError($0) }
        )
    }
    
    public func fork() {
        SwiftEventBus.post(ProgressForkEvent.NAME)
    }
    
    public func done() {
        SwiftEventBus.post(ProgressDoneEvent.NAME)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Caravel.getDefault(_webView).whenReady() { bus in
            bus.register(ProgressDoneEvent.NAME) { name, data in
                self.done()
            }
            
            bus.register(ProgressForkEvent.NAME) { name, data in
                self.fork()
            }
            
            bus.register("AskForRefreshingClassList") { name, data in
                self.fork()
                self._setClassListContent({ tuples in
                    bus.post("RefreshClassList", anArray: tuples!)
                    self.done()
                })
            }
            
            bus.register("RequireClassDetails") { name, data in
                var slug = data as! String
                
                BusinessFactory
                    .provideLesson()
                    .getSchoolClassTuple(
                        slug,
                        success: { (schoolClass, teacher, venue) in
                            bus.post(
                                "DisplayClassDetails",
                                aDictionary: [
                                    "schoolClass": schoolClass!.toDictionary(),
                                    "teacher": teacher!.toDictionary(),
                                    "venue": venue!.toDictionary()
                                ]
                            )
                        },
                        failure: { self.publishError($0) }
                )
            }
            
            self.fork()
            self._setClassListContent({ tuples in
                bus.post("DisplayClassList", anArray: tuples!)
                self.done()
            })
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("class_list", withExtension: "html")!))
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func publishError(message: String) {
        SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: message))
        done()
    }
}

