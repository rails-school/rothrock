//
//  ISharePluginOwner.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

public protocol ISharePluginOwner: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var controller: UIViewController { get }
    
    func fork()
    
    func done()
    
    func publishError(message: String)
}