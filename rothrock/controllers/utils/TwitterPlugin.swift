//
//  TwitterPlugin.swift
//  rothrock
//
//  Created by Adrien on 19/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

internal class TwitterPlugin {
    static func tweet(text: String) {
        let addressString = "https://twitter.com/intent/tweet?text=\(text)"
        
        UIApplication.sharedApplication().openURL(NSURL(string: addressString)!)
    }
}