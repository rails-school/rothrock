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

public class ClassListController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var _webView: UIWebView!
    
    private var _currentLesson: Lesson?
    private var _currentVenue: Venue?
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
    
    private func _getLessonURL() -> String {
        return "api_endpoint".localized + "/l/\(_currentLesson!.slug)"
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
                            self._currentLesson = schoolClass!.lesson
                            self._currentVenue = venue
                            
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
                                    self._currentLesson!.slug,
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
                        self._currentLesson!.id,
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
            
            bus.register("RequestClassDetailsCalendar") { name, data in
                var eventStore = EKEventStore()
                
                eventStore.requestAccessToEntityType(EKEntityTypeEvent) { granted, error in
                    if !granted {
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var event = EKEvent(eventStore: eventStore)
                        event.title = self._currentLesson!.title
                        event.startDate = NSDate.fromString(self._currentLesson!.startTime!)!
                        event.endDate = NSDate.fromString(self._currentLesson!.endTime!)!
                        event.notes = self._currentLesson!.summary!
                        event.location = self._currentVenue!.name!
                        event.calendar = eventStore.defaultCalendarForNewEvents
                        
                        eventStore.saveEvent(event, span: EKSpanThisEvent, error: NSErrorPointer())
                        
                        SwiftEventBus.post(ConfirmationEvent.NAME, sender: ConfirmationEvent(message: "added_to_calendar".localized))
                    }
                }
            }
            
            bus.register("RequestClassDetailsMap") { name, data in
                let addressString = "http://maps.apple.com/?q=\(self._currentVenue!.latitude),\(self._currentVenue!.longitude)";
                UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
            }
            
            bus.register("ClassDetailsText") { name, data in
                if MFMessageComposeViewController.canSendText() {
                    var controller = MFMessageComposeViewController()
                    var message = NSString(format: "class_share_text".localized, self._currentLesson!.title!)
                    
                    controller.body = message.substringToIndex(150) as String
                    controller.recipients = []
                    controller.messageComposeDelegate = self
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
            
            bus.register("ClassDetailsEmail") { name, data in
                if MFMailComposeViewController.canSendMail() {
                    var controller = MFMailComposeViewController()
                    
                    controller.setSubject("app_name".localized)
                    controller.setMessageBody(NSString(format: "class_share_text".localized + "\n\n %@", self._currentLesson!.title!, self._getLessonURL()) as String, isHTML: false)
                    controller.mailComposeDelegate = self
                    
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
            
            bus.register("ClassDetailsFacebook") { name, data in
                let addressString = "https://www.facebook.com/sharer/sharer.php?u=\(self._getLessonURL())";
                UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
            }
            
            bus.register("ClassDetailsTwitter") { name, data in
                let addressString = "https://twitter.com/intent/tweet?text=\(self._currentLesson!.title!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)%20\(self._getLessonURL())";
                UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
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
    
    public func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

