//
//  SharePlugin.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import Caravel
import MessageUI

public class SharePlugin {
    private var _owner: ISharePluginOwner
    
    init(owner: ISharePluginOwner, bus: Caravel) {
        self._owner = owner
        
        bus.register("TriggerShareText") { name, data in
            var slug = data as! String
            
            if MFMessageComposeViewController.canSendText() {
                self._owner.fork()
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            var controller = MFMessageComposeViewController()
                            var message = NSString(format: "class_share_text".localized, lesson!.title!)
                            
                            controller.body = message as String
                            controller.recipients = []
                            controller.messageComposeDelegate = self._owner
                            
                            self._owner.done()
                            self._owner.controller.presentViewController(controller, animated: true, completion: nil)
                        },
                        failure: { self._owner.publishError($0) }
                )
            }
        }
        
        bus.register("TriggerShareEmail") { name, data in
            var slug = data as! String
            
            if MFMailComposeViewController.canSendMail() {
                self._owner.fork()
                BusinessFactory
                    .provideLesson()
                    .get(
                        slug,
                        success: { lesson in
                            var controller = MFMailComposeViewController()
                            
                            controller.setSubject("app_name".localized)
                            controller.setMessageBody(NSString(format: "class_share_text".localized + "\n\n %@", lesson!.title!,BusinessFactory.provideLesson().getLessonURL(lesson!)) as String, isHTML: false)
                            controller.mailComposeDelegate = self._owner
                            
                            self._owner.done()
                            self._owner.controller.presentViewController(controller, animated: true, completion: nil)
                        },
                        failure: { self._owner.publishError($0) }
                )
            }
        }
        
        bus.register("TriggerShareFacebook") { name, data in
            var slug = data as! String
            
            self._owner.fork()
            BusinessFactory
                .provideLesson()
                .get(
                    slug,
                    success: { lesson in
                        let addressString = "https://www.facebook.com/sharer/sharer.php?u=\(BusinessFactory.provideLesson().getLessonURL(lesson!))"
                        
                        self._owner.done()
                        UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
                    },
                    failure: { self._owner.publishError($0) }
            )
        }
        
        bus.register("TriggerShareTwitter") { name, data in
            var slug = data as! String
            
            self._owner.fork()
            BusinessFactory
                .provideLesson()
                .get(
                    slug,
                    success: { lesson in
                        var message = lesson!.title!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                        
                        message += "%20\(BusinessFactory.provideLesson().getLessonURL(lesson!))"
                        
                        self._owner.done()
                        TwitterPlugin.tweet(message)
                    },
                    failure: { self._owner.publishError($0) }
            )
        }
    }
    
    
}