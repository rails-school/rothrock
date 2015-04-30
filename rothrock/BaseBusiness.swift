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
    
    internal class BLLCallback<T>: RemoteCallback<T> {
        init(success: (response: NSHTTPURLResponse?, data: T?) -> Void, failure: (String) -> Void) {
            super.init(success: success, failure: { (response, error) in processError(error, failure: failure) })
        }
    }
    
    internal init(api: IRailsSchoolAPI) {
        self._api = api
    }
    
    internal var api: IRailsSchoolAPI {
        return _api
    }
    
    internal func processError(error: NSError?, failure: (String) -> Void) {
        NSLog(NSStringFromClass(BaseBusiness.self), error!.description)
        // TODO: call failure
    }
}