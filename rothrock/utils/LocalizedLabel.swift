//
//  LocalizedLabel.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class LocalizedLabel: UILabel {
    public override func awakeFromNib() {
        if let t = text {
            text = t.localized
        }
    }
}