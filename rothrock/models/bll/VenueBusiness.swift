//
//  VenueBusiness.swift
//  rothrock
//
//  Created by Adrien on 15/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class VenueBusiness: BaseBusiness, IVenueBusiness {
    private static let COOLDOWN_SEC = 20 * 60
    
    private var _venueDAO: IVenueDAO
    
    internal init(api: IRailsSchoolAPI, venueDao: IVenueDAO) {
        self._venueDAO = venueDao
        
        super.init(api: api)
    }
    
    func get(id: Int, success: (Venue?) -> Void, failure: (String) -> Void) {
        if _venueDAO.exists(id) {
            var v = _venueDAO.find(id)
            
            success(v)
            
            if NSDate().dateBySubtractingSeconds(v!.updateDate!.second()).second() >= VenueBusiness.COOLDOWN_SEC {
                api.getVenue(id, callback: BLLCallback(base: self, success: { self._venueDAO.save($1!) }, failure: failure))
            }
        } else {
            api.getVenue(id, callback: BLLCallback(base: self, success: { success($1); self._venueDAO.save($1!) }, failure: failure))
        }
    }
}