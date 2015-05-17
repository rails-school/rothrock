//
//  LocalizedTextField.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class LocalizedTextField: UITextField {
    public override func awakeFromNib() {
        if let p = placeholder {
            placeholder = p.localized
        }
    }
}