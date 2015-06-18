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

internal class ClassListController: BaseController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    private var _bus: Caravel?
    
    internal override init(parentController: UIViewController, webView: UIWebView) {
        super.init(parentController: parentController, webView: webView)
    }
    
    override func onStart() {
        Caravel.get("ClassListController", webView: webView).whenReady() { bus in
            self._bus = bus
            
            bus.register("TriggerInsight") { name, data in
                var slug = data as! String
            }
            
            bus.register("TriggerShareText") { name, data in
                var slug = data as! String
                
                if MFMessageComposeViewController.canSendText() {
                    BusinessFactory
                        .provideLesson()
                        .get(
                            slug,
                            success: { lesson in
                                var controller = MFMessageComposeViewController()
                                var message = NSString(format: "class_share_text".localized, lesson!.title!)
                                
                                controller.body = message.substringToIndex(150) as String
                                controller.recipients = []
                                controller.messageComposeDelegate = self
                                
                                self.parentController.presentViewController(controller, animated: true, completion: nil)
                            },
                            failure: { self.publishError($0) }
                        )
                }
            }
            
            bus.register("TriggerShareEmail") { name, data in
                var slug = data as! String
                
                if MFMailComposeViewController.canSendMail() {
                    BusinessFactory
                        .provideLesson()
                        .get(
                            slug,
                            success: { lesson in
                                var controller = MFMailComposeViewController()
                                
                                controller.setSubject("app_name".localized)
                                controller.setMessageBody(NSString(format: "class_share_text".localized + "\n\n %@", lesson!.title!,BusinessFactory.provideLesson().getLessonURL(lesson!)) as String, isHTML: false)
                                controller.mailComposeDelegate = self
                                
                                self.parentController.presentViewController(controller, animated: true, completion: nil)
                            },
                            failure: { self.publishError($0) }
                        )
                }
            }
            
            bus.register("TriggerShareFacebook") { name, data in
                var slug = data as! String
                
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            let addressString = "https://www.facebook.com/sharer/sharer.php?u=\(BusinessFactory.provideLesson().getLessonURL(lesson!))";
                            UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
                        },
                        failure: { self.publishError($0) }
                    )
            }
            
            bus.register("TriggerShareTwitter") { name, data in
                var slug = data as! String
                
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            let addressString = "https://twitter.com/intent/tweet?text=\(lesson!.title!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)%20\(BusinessFactory.provideLesson().getLessonURL(lesson!))";
                            UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
                        },
                        failure: { self.publishError($0) }
                )
            }
            
            self.onResume()
        }
    }
    
    override func onResume() {
        if (_bus == nil) {
            return;
        }
        
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
    
    // MFMessageComposeViewControllerDelegate
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}