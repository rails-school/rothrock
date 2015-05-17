//
//  ClassTableCell.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

public class ClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var _headline: UILabel!
    @IBOutlet weak var _teacherName: UILabel!
    @IBOutlet weak var _digest: UILabel!
    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _location: UILabel!
    
    public func hydrate(slug: String) {
        SwiftEventBus.post(ControllerEvents.ProgressForkEvent.rawValue)
        
        BusinessFactory
            .provideLesson()
            .getTuple(
                slug,
                success: { (lesson, teacher, venue) in
                    self._headline.text = lesson!.title
                    self._digest.text = lesson!.summary
                    self._date.text = NSDate.userFriendly(lesson!.startTime!)
                    
                    self._teacherName.text = teacher!.displayedName
                    self._location.text = venue!.name
                    
                    SwiftEventBus.post(ControllerEvents.ProgressDoneEvent.rawValue)
                },
                failure: {
                    SwiftEventBus.post(ControllerEvents.ErrorEvent.rawValue, sender: $0)
                    SwiftEventBus.post(ControllerEvents.ProgressDoneEvent.rawValue)
                }
        )
    }
}