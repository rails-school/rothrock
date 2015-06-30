//
//  BaseBusiness'.swift
//  rothrock
//
//  Created by Adrien on 29/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class BaseBusiness {
    private var _api: IRailsSchoolAPI
    
    internal init(api: IRailsSchoolAPI) {
        self._api = api        
    }
    
    internal var api: IRailsSchoolAPI {
        return _api
    }
    
    internal func getDefaultErrorMsg() -> String {
        return "error_default".localized
    }
    
    internal func processError(error: NSError, failure: (String) -> Void) {
        NSLog("%@: %@", NSStringFromClass(BaseBusiness.self), error.description)
        failure(getDefaultErrorMsg())
    }
}