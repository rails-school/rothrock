//
//  ClassDetailsController.swift
//  rothrock
//
//  Created by Adrien on 18/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus
import SnapKit

public class ClassDetailsController: BaseController {
    
    @IBOutlet weak var _header: UIView!
    @IBOutlet weak var _headline: UILabel!
    @IBOutlet weak var _digest: UILabel!
    @IBOutlet weak var _dateIcon: UIImageView!
    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _locationIcon: UIImageView!
    @IBOutlet weak var _location: UILabel!
    
    private func _layout() {
        _header.snp_remakeConstraints { make in
            make.top.equalTo(self._header.superview!)
            make.left.equalTo(self._header.superview!)
            make.right.equalTo(self._header.superview!)
            
            make.width.equalTo(self._header.superview!.superview!)
        }
        
        _headline.snp_remakeConstraints { make in
            make.top.equalTo(self._headline.superview!).offset(8)
            make.left.equalTo(self._headline.superview!).offset(8)
            make.right.equalTo(self._headline.superview!).offset(8)
            
            make.width.lessThanOrEqualTo(self._headline.superview!)
        }
        
        _digest.snp_remakeConstraints { make in
            make.top.equalTo(self._headline.snp_bottom).offset(8)
            make.left.equalTo(self._digest.superview!).offset(8)
            make.right.equalTo(self._digest.superview!).offset(8)
            
            make.width.lessThanOrEqualTo(self._digest.superview!)
            self._digest.preferredMaxLayoutWidth = self._digest.superview!.bounds.size.width
        }
        
        _dateIcon.snp_remakeConstraints { make in
            make.top.equalTo(self._digest.snp_bottom).offset(8)
            make.left.equalTo(self._dateIcon.superview!).offset(8 * 2)
            
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        _date.snp_remakeConstraints { make in
            make.top.equalTo(self._digest.snp_bottom).offset(8)
            make.left.equalTo(self._dateIcon).offset(8)
            
            make.width.lessThanOrEqualTo(100)
            //make.width.lessThanOrEqualTo(self._date.superview!.snp_width).offset(CGSizeMake(-(50 * 2 - 8 * 2 * 2), 0))
        }
        
        _location.snp_remakeConstraints { make in
            make.top.equalTo(self._digest.snp_bottom).offset(8)
            make.right.equalTo(self._location.superview!).offset(8 * 2)
            
            make.width.equalTo(self._date)
        }
        
        _locationIcon.snp_remakeConstraints { make in
            make.top.equalTo(self._digest.snp_bottom).offset(8)
            make.right.equalTo(self._location).offset(8)
            
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.post(ProgressForkEvent.NAME)
        SwiftEventBus.onMainThread(self, name: ClassDetailsInitEvent.NAME) { notif in
            var e = notif.object as! ClassDetailsInitEvent
            
            BusinessFactory
                .provideLesson()
                .getSchoolClassTuple(
                    e.lessonSlug,
                    success: { (schoolClass, teacher, venue) in
                        self._headline.text = schoolClass!.lesson!.title
                        self._digest.text = schoolClass!.lesson!.summary
                        
                        self._layout()
                        
                        SwiftEventBus.post(ProgressDoneEvent.NAME)
                    },
                    failure: {
                        self.publishError($0)
                    }
                )
        }
    }
}