//
//  SingleClassController.swift
//  Rails School
//
//  Created by Adrien on 23/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import Caravel
import SwiftEventBus
import MessageUI

public class SingleClassController: BaseController, ISharePluginOwner, IDeviceInterfaceOwner {
    
    @IBOutlet weak var _webView: UIWebView!
    
    private var _slug: String?
    private var _bus: Caravel?
    
    private var _sharePlugin: SharePlugin?
    private var _deviceInterface: DeviceInterface?
    
    public var controller: UIViewController {
        return self
    }
    
    private func _sendClass() {
        BusinessFactory
            .provideLesson()
            .getSchoolClassTupleAsDictionary(
                _slug!,
                success: { dict in
                    self._bus!.post("ReceiveClass", aDictionary: dict!)
                    self.done()
                },
                failure: { self.publishError($0) }
        )
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        fork()
        SwiftEventBus.onMainThread(self, name: SingleClassInitEvent.NAME) { notif in
            var e = notif.object as! SingleClassInitEvent
            
            self._slug = e.slug
            if self._bus != nil { // JS bus ready before that event, notify JS then
                self._sendClass()
            }
        }
        
        Caravel.get("SingleClassController", webView: _webView).whenReady() { bus in
            self._bus = bus
            if self._slug != nil { // Slug has been received, notify JS then
                self._sendClass()
            }
            
            bus.register("CloseInsight") { _, _ in
                self.dismissViewControllerAnimated(true) {
                    SwiftEventBus.post(ClosedSingleClassControllerEvent.NAME)
                }
            }
            
            bus.register("ToggleAttendance") { name, data in
                self.fork()
                BusinessFactory
                    .provideUser()
                    .isCurrentUserAttendingTo(
                        self._slug!,
                        isAttending: { isAttending in
                            BusinessFactory
                                .provideLesson()
                                .get(
                                    self._slug!,
                                    success: { lesson in
                                        BusinessFactory
                                            .provideUser()
                                            .toggleAttendance(
                                                lesson!.id,
                                                newValue: !isAttending,
                                                success: {
                                                    self.done()
                                                    self.confirm("saved_confirmation".localized)
                                                    self._sendClass()
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
        }
        
        _webView.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("main_single_class", withExtension: "html")!))
    }
    
    // MFMessageComposeViewControllerDelegate
    public func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MFMailComposeViewControllerDelegate
    public func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
