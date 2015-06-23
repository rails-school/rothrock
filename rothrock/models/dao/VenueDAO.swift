//
//  VenueDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class VenueDAO: BaseDAO, IVenueDAO {
    func exists(id: Int) -> Bool {
        if let v = find(id) {
            return true
        } else {
            return false
        }
    }
    
    func find(id: Int) -> Venue? {
        var pred = NSPredicate(format: "id = %d", id)
        return Venue.objectsInRealm(dal, withPredicate: pred).firstObject() as! Venue?
    }
    
    func save(venue: Venue) {
        dal.beginWriteTransaction()
        venue.updateDate = NSDate()
        Venue.createOrUpdateInRealm(dal, withValue: venue)
        dal.commitWriteTransaction()
    }
}