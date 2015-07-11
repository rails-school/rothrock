//
//  Venue.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class Venue: RLMObject {
    public dynamic var id: Int = 0
    
    public dynamic var zip: String?
    public dynamic var latitude: Float = 0.0
    public dynamic var longitude: Float = 0.0
    public dynamic var name: String?
    public dynamic var address: String?
    public dynamic var city: String?
    public dynamic var state: String?
    public dynamic var country: String?
    public dynamic var updateDate: NSDate?
    
    public override class func primaryKey() -> String {
        return "id"
    }
}