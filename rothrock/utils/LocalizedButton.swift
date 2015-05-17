//
//  LocalizedButton.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class LocalizedButton: UIButton {
    public override func awakeFromNib() {
        if let t = titleLabel {
            setTitle(t.text!.localized, forState: UIControlState.Normal)
        }
    }
}