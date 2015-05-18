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
        SwiftEventBus.post(ProgressForkEvent.NAME)
        
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
                    
                    SwiftEventBus.post(ProgressDoneEvent.NAME)
                },
                failure: {
                    SwiftEventBus.post(ErrorEvent.NAME, sender: ErrorEvent(message: $0))
                    SwiftEventBus.post(ProgressDoneEvent.NAME)
                }
        )
    }
}