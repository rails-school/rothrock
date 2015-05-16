//
//  VenueSerializer.swift
//  rothrock
//
//  Created by Adrien on 27/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class IVenueDeserializer: IJSONDeserializer {
    typealias T = Venue
    
    public func deserialize(json: JSON) -> Venue {
        return Venue()
    }
}

internal class VenueSerializer: IVenueDeserializer {
    
    override func deserialize(json: JSON) -> Venue {
        var outcome = Venue()
        
        outcome.id = json["id"].intValue
        outcome.zip = json["zip"].stringValue
        outcome.latitude = json["latitude"].floatValue
        outcome.longitude = json["longitude"].floatValue
        outcome.name = json["name"].stringValue
        outcome.address = json["address"].stringValue
        outcome.city = json["city"].stringValue
        outcome.state = json["state"].stringValue
        outcome.country = json["country"].stringValue
        
        return outcome
    }
}