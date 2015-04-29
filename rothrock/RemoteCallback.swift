//
//  APICallback.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import SwiftyJSON

public class RemoteCallback<U> {
    private var _success: (response: NSHTTPURLResponse?, data: U?) -> Void
    private var _failure: (response: NSHTTPURLResponse?, error: NSError?) -> Void
    
    init(success: (response: NSHTTPURLResponse?, data: U?) -> Void, failure: (response: NSHTTPURLResponse?, error: NSError?) -> Void) {
        self._success = success
        self._failure = failure
    }
    
    internal func asHandler<A: IJSONDeserializer where A.T == U>(serializer: A) -> (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void {
        return { (request, response, data, error) in
            if let e = error {
                self._failure(response: response, error: error)
            } else {
                if let o = data {
                    self._success(response: response, data: serializer.deserialize(JSON(o)))
                } else {
                    self._success(response: response, data: nil)
                }
            }
        }
    }
}