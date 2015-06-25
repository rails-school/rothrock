//
//  IDeviceInterfaceOwner.swift
//  Rails School
//
//  Created by Adrien on 24/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IDeviceInterfaceOwner {
    func fork()
    
    func done()
    
    func publishError(message: String)
    
    func confirm(message: String)
}