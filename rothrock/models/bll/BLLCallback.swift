//
//  BLLCallback.swift
//  rothrock
//
//  Created by Adrien on 14/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

internal class BLLCallback<T>: RemoteCallback<T> {
    init(base: BaseBusiness, success: (response: NSHTTPURLResponse?, data: T?) -> Void, failure: (String) -> Void) {
        super.init(success: success, failure: { (response, error) in base.processError(error, failure: failure) })
    }
}
