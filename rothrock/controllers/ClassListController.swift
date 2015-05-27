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
    
    private var _currentLessonId: Int?
    private var _currentLessonSlug: String?
    private var _isAttendingCurrentLesson: Bool?
    
    private func _setClassListContent(callback: ([NSDictionary]?) -> Void) {
        BusinessFactory
            .provideLesson()
            .sortFutureTuplesByDate(
                callback,
                failure: { self.publishError($0) }
        )
    }
    
    private func _sendSetAttendance() {
        Caravel.getDefault(_webView).post("SetAttendance", aBool: _isAttendingCurrentLesson!)
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
                            self._currentLessonId = schoolClass!.lesson!.id
                            self._currentLessonSlug = schoolClass!.lesson!.slug
                            
                            bus.post(
                                "DisplayClassDetails",
                                aDictionary: [
                                    "schoolClass": schoolClass!.toDictionary(),
                                    "teacher": teacher!.toDictionary(),
                                    "venue": venue!.toDictionary()
                                ]
                            )
                            
                            BusinessFactory
                                .provideUser()
                                .isCurrentUserAttendingTo(
                                    self._currentLessonSlug!,
                                    isAttending: { isAttending in
                                        bus.post("CanIToggleAttendance", aBool: true)
                                        self._isAttendingCurrentLesson = isAttending
                                        self._sendSetAttendance()
                                    },
                                    needToSignIn: {
                                        bus.post("CanIToggleAttendance", aBool: false)
                                    },
                                    failure: { self.publishError($0) }
                            )
                        },
                        failure: { self.publishError($0) }
                )
            }
            
            bus.register("UpdateAttendance") { name, data in
                var newValue = data as! Bool
                
                BusinessFactory
                    .provideUser()
                    .toggleAttendance(
                        self._currentLessonId!,
                        isAttending: !self._isAttendingCurrentLesson!,
                        success: {
                            self._isAttendingCurrentLesson = !self._isAttendingCurrentLesson!
                            self._sendSetAttendance()
                            
                            SwiftEventBus.post(ConfirmationEvent.NAME, sender: ConfirmationEvent(message: "saved_confirmation".localized))
                        },
                        failure: { self.publishError($0) }
                        )
            }
            
            bus.register("UnableToToggleAttendance") { name, data in
                SwiftEventBus.post(InformationEvent.NAME, sender: InformationEvent(message: "error_not_signed_in".localized))
            }
            
            // Init part
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

