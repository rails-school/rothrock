//
//  SettingsController.swift
//  rothrock
//
//  Created by Adrien on 19/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import Caravel

internal class SettingsController: BaseController {
    private var _bus: Caravel?
    
    override init(parentController: UIViewController, webView: UIWebView) {
        super.init(parentController: parentController, webView: webView)
    }
    
    private func _confirmSaving() {
        confirm("saved_confirmation".localized)
    }
    
    private func _onceBusReady() {
        _bus!.post("SetSettings", aDictionary: [
            "email": BusinessFactory.provideUser().getCurrentUserEmail() ?? "",
            "twoHourReminder": BusinessFactory.providePreference().getTwoHourReminderPreference()!.rawValue,
            "dayReminder": BusinessFactory.providePreference().getDayReminderPreference()!.rawValue,
            "newLessonAlert": BusinessFactory.providePreference().getLessonAlertPreference()
        ])
    }
    
    override func onStart() {
        Caravel.get("SettingsController", webView: webView).whenReady() { bus in
            self._bus = bus
            
            bus.register("SaveCredentials") { name, data in
                var dict = data as! NSDictionary
                
                self.fork()
                BusinessFactory
                    .provideUser()
                    .checkCredentials(
                        dict["email"] as! String,
                        password: dict["password"] as! String,
                        success: {
                            self.done()
                            self._confirmSaving()
                        },
                        failure: { self.publishError($0) }
                    )
            }
            
            bus.register("TwoHourReminderNewValue") { name, data in
                var value = data as! Int
                
                BusinessFactory.providePreference().updateTwoHourReminderPreference(TwoHourNotificationPreference(rawValue: value)!)
                self._confirmSaving()
            }
            
            bus.register("DayReminderNewValue") { name, data in
                var value = data as! Int
                
                BusinessFactory.providePreference().updateDayReminderPreference(DayNotificationPreference(rawValue: value)!)
                self._confirmSaving()
            }
            
            bus.register("LessonAlertNewValue") { name, data in
                var value = data as! Int
                
                BusinessFactory.providePreference().updateLessonAlertPreference(value == 1)
                self._confirmSaving()
            }
            
            bus.register("LogOut") { name, data in
                BusinessFactory.provideUser().logOut()
                self.confirm("settings_successful_log_out")
            }
            
            bus.register("Twitter") { name, data in
                TwitterPlugin.tweet("@railsschoolsf")
            }
            
            self._onceBusReady()
        }
    }
    
    override func onResume() {
        if _bus == nil {
            return
        }
        
        _onceBusReady()
    }
}