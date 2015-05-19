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

public class ClassDetailsController: BaseController, UITableViewDelegate {
    
    @IBOutlet weak var _headline: UILabel!
    @IBOutlet weak var _digest: UILabel!
    
    private var _date: UITableViewCell?
    private var _location: UITableViewCell?
    private var _teacher: UITableViewCell?
    private var _attendees: UITableViewCell?
    private var _description: UITableViewCell?
    private var _attendanceToggle: UITableViewCell?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(self, name: ClassDetailsInitEvent.NAME) { notif in
            var e = notif.object as! ClassDetailsInitEvent
            
            BusinessFactory
                .provideLesson()
                .getSchoolClassTuple(
                    e.lessonSlug,
                    success: { (schoolClass, teacher, venue) in
                        self._headline.text = schoolClass!.lesson!.title
                        self._digest.text = schoolClass!.lesson!.summary
                    },
                    failure: { self.publishError($0) }
                )
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "Embed" {
            var controller = segue.destinationViewController as! UITableViewController
            var tableView = controller.view as! UITableView
            
            tableView.delegate = self
        }
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                _date = cell
            case 1:
                _location = cell
            default:
                _teacher = cell
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                _attendees = cell
            default:
                _description = cell
            }
        } else {
            _attendanceToggle = cell
        }
    }
}