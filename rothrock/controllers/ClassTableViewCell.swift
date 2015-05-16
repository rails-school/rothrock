//
//  ClassTableCell.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class ClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var _headline: UILabel!
    @IBOutlet weak var _teacherName: UILabel!
    @IBOutlet weak var _digest: UILabel!
    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _location: UILabel!
    
    public func hydrate(slug: String) {
        BusinessFactory
            .provideLesson()
            .getTuple(
                slug,
                success: { (lesson, teacher, venue) in
                    self._headline.text = lesson!.title
                    self._digest.text = lesson!.summary
                    self._teacherName.text = teacher!.name
                },
                failure: { (error) in
                }
            )
    }
}