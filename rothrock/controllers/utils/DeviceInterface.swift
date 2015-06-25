//
//  DeviceInterface.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import Caravel
import EventKit

public class DeviceInterface {
    
    public init(owner: IDeviceInterfaceOwner, bus: Caravel) {
        bus.register("AddToCalendar") { name, data in
            var slug = data as! String
            var eventStore = EKEventStore()
            
            owner.fork()
            eventStore.requestAccessToEntityType(EKEntityTypeEvent) { granted, error in
                if !granted {
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    BusinessFactory
                        .provideLesson()
                        .getTuple(
                            slug,
                            success: { lesson, teacher, venue in
                                var event = EKEvent(eventStore: eventStore)
                                
                                event.title = lesson!.title!
                                event.startDate = NSDate.fromString(lesson!.startTime!)!
                                event.endDate = NSDate.fromString(lesson!.endTime!)!
                                event.notes = lesson!.summary!
                                event.location = venue!.name!
                                event.calendar = eventStore.defaultCalendarForNewEvents
                            
                                dispatch_async(dispatch_get_main_queue()) {
                                    eventStore.saveEvent(event, span: EKSpanThisEvent, error: NSErrorPointer())
                                    owner.done()
                                    owner.confirm("added_to_calendar".localized)
                                }
                            },
                            failure: { owner.publishError($0) }
                        )
                }
            }
            
        }
        
        bus.register("AddToMap") { name, data in
            var slug = data as! String
            
            BusinessFactory
                .provideLesson()
                .getTuple(
                    slug,
                    success: { lesson, teacher, venue in
                        let addressString = "http://maps.apple.com/?q=\(venue!.latitude),\(venue!.longitude)";
                        UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
                    },
                    failure: { owner.publishError($0) }
            )
        }
    }
}