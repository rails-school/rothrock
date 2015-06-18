//
//  ClassListController.swift
//  rothrock
//
//  Created by Adrien on 15/06/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import Caravel

internal class ClassListController: BaseController {
    private var _bus: Caravel?
    
    internal override init(webView: UIWebView) {
        super.init(webView: webView)
    }
    
    override func onStart() {
        Caravel.get("ClassListController", webView: webView).whenReady() { bus in
            self._bus = bus
            
            self.onResume()
        }
    }
    
    override func onResume() {
        if (_bus == nil) {
            return;
        }
        
        fork()
        BusinessFactory
            .provideLesson()
            .sortFutureSchoolClassesByDateAsDictionary(
                { (dictionaries) in
                    self._bus!.post("ReceiveClasses", anArray: dictionaries!)
                    self.done()
                },
                failure: { self.publishError($0) }
            )
        
        if BusinessFactory.provideUser().isSignedIn() {
            self._bus!.post("ReceiveSchool", aString: BusinessFactory.provideUser().getCurrentUserSchoolSlug())            
        }
    }
}