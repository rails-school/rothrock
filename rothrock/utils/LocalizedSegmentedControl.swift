//
//  LocalizedSegmentControl.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class LocalizedSegmentedControl: UISegmentedControl {
    public override func awakeFromNib() {
        for i in 0..<numberOfSegments {
            if let t = titleForSegmentAtIndex(i) {
                setTitle(t.localized, forSegmentAtIndex: i)
            }
        }
    }
}