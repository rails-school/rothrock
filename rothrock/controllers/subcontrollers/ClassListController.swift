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

internal class ClassListController: SubController, ISharePluginOwner, IDeviceInterfaceOwner {
    private var _bus: Caravel?
    private var _sharePlugin: SharePlugin?
    private var _deviceInterface: DeviceInterface?
    
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
                                                    self.confirm("saved_confirmation".localized)
                                                    self._onceBusReady()
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
            
            self._sharePlugin = SharePlugin(owner: self, bus: bus)
            self._deviceInterface = DeviceInterface(owner: self, bus: bus)
            
            self._onceBusReady()
        }
    }
    
    override func onResume() {
        if (_bus == nil) {
            return;
        }
        
        _onceBusReady()
    }
    
    func presentViewController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        parentController.presentViewController(controller, animated: animated, completion: completion)
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