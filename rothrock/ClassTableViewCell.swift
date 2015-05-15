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
    
    @IBOutlet weak var _teacher: UILabel!
    
    @IBOutlet weak var _digest: UILabel!
    
    public func hydrate(slug: String) {
        BusinessFactory
            .provideLesson()
            .getTuple(
                slug,
                success: { (lesson, teacher, venue) in
                    self._headline.text = lesson!.title
                    self._digest.text = lesson!.summary
                    self._teacher.text = teacher!.name
                },
                failure: { (error) in
                }
            )
    }
}