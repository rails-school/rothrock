//
//  IVenueDAO.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public protocol IVenueDAO {
    func exists(id: Int) -> Bool
    
    func find(id: Int) -> Venue?
    
    func save(venue: Venue)
    
    func getLatestClean() -> NSDate?
    
    func truncateTable()
}