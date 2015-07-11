//
//  AppDelegate.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit
import SwiftEventBus
import SCLAlertView
import KVNProgress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var _backgroundThreads = 0
    private var _backgroundTimer: NSTimer?
    
    private var _alarmManager: AlarmManager?
    
    func timerHandler() {
        _backgroundTimer = nil
        KVNProgress.show()
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set spinner configuration
        var config = KVNProgressConfiguration()
        config.circleStrokeForegroundColor = UIColor(white: 0.8, alpha: 1)
        config.backgroundTintColor = UIColor(white: 1.0, alpha: 0.8)
        config.backgroundType = KVNProgressBackgroundType.Blurred
        config.circleSize = 100
        config.lineWidth = 3
        config.fullScreen = true
        KVNProgress.setConfiguration(config)
        
        // Sets up alarms
        _alarmManager = AlarmManager(application: application)
        application.setMinimumBackgroundFetchInterval(Double(AlarmManager.PERIOD_MILLI / 1000))
        
        // Sets up push notifications
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil))
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        KVNProgress.dismiss()
        if let t = _backgroundTimer {
            t.invalidate()
        }
        
        SwiftEventBus.unregister(self)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        _backgroundThreads = 0
        
        // Progress events
        SwiftEventBus.onMainThread(self, name: ProgressForkEvent.NAME) { _ in
            self._backgroundThreads++
            
            if self._backgroundThreads == 1 {
                self._backgroundTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("timerHandler"), userInfo: nil, repeats: false)
            }
        }
        
        SwiftEventBus.onMainThread(self, name: ProgressDoneEvent.NAME) { _ in
            self._backgroundThreads--
            
            if let t = self._backgroundTimer {
                t.invalidate()
            } else {
                KVNProgress.dismiss()
            }
        }
        
        // Toaster events
        SwiftEventBus.onMainThread(self, name: ErrorEvent.NAME) { notif in
            var e = (notif.object) as! ErrorEvent
            SCLAlertView().showError("Error", subTitle: e.message, closeButtonTitle: "Ok", duration: 3)
        }
        SwiftEventBus.onMainThread(self, name: ConfirmationEvent.NAME) { notif in
            var e = (notif.object) as! ConfirmationEvent
            SCLAlertView().showSuccess("Confirmation", subTitle: e.message, closeButtonTitle: "Ok", duration: 3)
        }
        SwiftEventBus.onMainThread(self, name: InformationEvent.NAME) { notif in
            var e = (notif.object) as! InformationEvent
            SCLAlertView().showInfo("Information", subTitle: e.message, closeButtonTitle: "Ok", duration: 3)
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Push notifications have been allowed, save device token
        BusinessFactory.provideUser().saveDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("%@", error)
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let a = _alarmManager {
            a.trigger() {
                completionHandler(UIBackgroundFetchResult.NewData)
            }
        }
    }
}

