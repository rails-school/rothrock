//
//  APICallback.swift
//  rothrock
//
//  Created by Adrien on 24/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation

public class RemoteCallback<T> {
    private var _success: (response: NSHTTPURLResponse?, data: T?) -> Void
    private var _failure: (response: NSHTTPURLResponse?, error: NSError?) -> Void
    
    init(success: (response: NSHTTPURLResponse?, data: T?) -> Void, failure: (response: NSHTTPURLResponse?, error: NSError?) -> Void) {
        self._success = success
        self._failure = failure
    }
    
    internal func asHandler() -> (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void {
        return { (request, response, data, error) in
            if let e = error {
                self._failure(response: response, error: error)
            } else {
                self._success(response: response, data: data as! T?)
            }
        }
    }
}