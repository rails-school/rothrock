//
//  IDeviceInterfaceOwner.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public protocol IDeviceInterfaceOwner {
    func presentViewController(controller: UIViewController, animated: Bool, completion: (() -> Void)?)
    
    func fork()
    
    func done()
    
    func publishError(message: String)
    
    func confirm(message: String)
}