//
//  AppDelegate.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit
import SwiftEventBus
import SwiftSpinner
import JLToast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var _backgroundThreads = 0
    private var _backgroundTimer: NSTimer?
    
    private func _timerHandler() {
        _backgroundTimer = nil
        SwiftSpinner.show("", animated: false)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Progress events
        SwiftEventBus.onMainThread(self, name: ControllerEvents.ProgressForkEvent.rawValue) { _ in
            self._backgroundThreads++
            
            if self._backgroundThreads == 1 {
                self._backgroundTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("_timerHandler"), userInfo: nil, repeats: false)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: ControllerEvents.ProgressDoneEvent.rawValue) { _ in
            self._backgroundThreads--
            
            if let t = self._backgroundTimer {
                self._backgroundTimer?.invalidate()
            } else {
                SwiftSpinner.hide()
            }
        }
        
        // Toaster events
        SwiftEventBus.onMainThread(self, name: ControllerEvents.ErrorEvent.rawValue) { notif in
            JLToast.makeText(notif.object as! String).show()
        }
        SwiftEventBus.onMainThread(self, name: ControllerEvents.ConfirmationEvent.rawValue) { notif in
            JLToast.makeText(notif.object as! String).show()
        }
        SwiftEventBus.onMainThread(self, name: ControllerEvents.InformationEvent.rawValue) { notif in
            JLToast.makeText(notif.object as! String).show()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        SwiftSpinner.hide()
        if let t = _backgroundTimer {
            t.invalidate()
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        _backgroundThreads = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

