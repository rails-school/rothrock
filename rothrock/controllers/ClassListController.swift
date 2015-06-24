//
//  ClassListController.swift
//  rothrock
//
//  Created by Adrien on 15/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import Caravel
import MessageUI
import SwiftEventBus

internal class ClassListController: BaseController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    private var _bus: Caravel?
    
    internal override init(parentController: UIViewController, webView: UIWebView) {
        super.init(parentController: parentController, webView: webView)
    }
    
    private func _onceBusReady() {
        fork()
        BusinessFactory
            .provideLesson()
            .sortFutureSchoolClassesByDateAsDictionary(
                { (dictionaries) in
                    self._bus!.post("ReceiveClasses", anArray: dictionaries!)
                    self.done()
                },
                failure: { self.publishError($0) }
        )
        
        if BusinessFactory.provideUser().isSignedIn() {
            self._bus!.post("ReceiveSchool", aString: BusinessFactory.provideUser().getCurrentUserSchoolSlug())
        }
    }
    
    override func onStart() {
        Caravel.get("ClassListController", webView: webView).whenReady() { bus in
            self._bus = bus
            
            bus.register("TriggerInsight") { name, data in
                var slug = data as! String
                SwiftEventBus.post(PresentSingleClassControllerEvent.NAME, sender: PresentSingleClassControllerEvent(slug: slug))
            }
            
            bus.register("ToggleAttendance") { name, data in
                var slug = data as! String
                
                self.fork()
                BusinessFactory
                    .provideUser()
                    .isCurrentUserAttendingTo(
                        slug,
                        isAttending: { isAttending in
                            BusinessFactory
                                .provideLesson()
                                .get(
                                    slug,
                                    success: { lesson in
                                        BusinessFactory
                                            .provideUser()
                                            .toggleAttendance(
                                                lesson!.id,
                                                newValue: !isAttending,
                                                success: {
                                                    self.done()
                                                    bus.post(
                                                        "SetAttendance",
                                                        aDictionary: ["slug": slug, "isAttending": !isAttending]
                                                    )
                                                    self.confirm("saved_confirmation".localized)
                                                },
                                                failure: { self.publishError($0) }
                                            )
                                    },
                                    failure: { self.publishError($0) }
                                )
                        },
                        needToSignIn: {
                            self.done()
                            self.alert("error_not_signed_in".localized)
                        },
                        failure: { self.publishError($0) }
                    )
            }
            
            bus.register("TriggerShareText") { name, data in
                var slug = data as! String
                
                if MFMessageComposeViewController.canSendText() {
                    self.fork()
                    BusinessFactory
                        .provideLesson()
                        .get(
                            slug,
                            success: { lesson in
                                var controller = MFMessageComposeViewController()
                                var message = NSString(format: "class_share_text".localized, lesson!.title!)
                                
                                controller.body = message as String
                                controller.recipients = []
                                controller.messageComposeDelegate = self
                                
                                self.done()
                                self.parentController.presentViewController(controller, animated: true, completion: nil)
                            },
                            failure: { self.publishError($0) }
                        )
                }
            }
            
            bus.register("TriggerShareEmail") { name, data in
                var slug = data as! String
                
                if MFMailComposeViewController.canSendMail() {
                    self.fork()
                    BusinessFactory
                        .provideLesson()
                        .get(
                            slug,
                            success: { lesson in
                                var controller = MFMailComposeViewController()
                                
                                controller.setSubject("app_name".localized)
                                controller.setMessageBody(NSString(format: "class_share_text".localized + "\n\n %@", lesson!.title!,BusinessFactory.provideLesson().getLessonURL(lesson!)) as String, isHTML: false)
                                controller.mailComposeDelegate = self
                                
                                self.done()
                                self.parentController.presentViewController(controller, animated: true, completion: nil)
                            },
                            failure: { self.publishError($0) }
                        )
                }
            }
            
            bus.register("TriggerShareFacebook") { name, data in
                var slug = data as! String
                
                self.fork()
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            let addressString = "https://www.facebook.com/sharer/sharer.php?u=\(BusinessFactory.provideLesson().getLessonURL(lesson!))"
                            
                            self.done()
                            UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
                        },
                        failure: { self.publishError($0) }
                    )
            }
            
            bus.register("TriggerShareTwitter") { name, data in
                var slug = data as! String
                
                self.fork()
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            var message = lesson!.title!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                            
                            message += "%20\(BusinessFactory.provideLesson().getLessonURL(lesson!))"
                            
                            self.done()
                            TwitterPlugin.tweet(message)
                        },
                        failure: { self.publishError($0) }
                )
            }
            
            self._onceBusReady()
        }
    }
    
    override func onResume() {
        if (_bus == nil) {
            return;
        }
        
        _onceBusReady()
    }
    
    // MFMessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}