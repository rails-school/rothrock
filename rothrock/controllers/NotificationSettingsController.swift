//
//  NotificationSettings.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit

public class NotificationSettingsController: BaseController, UITableViewDelegate {
    private var _currentTwoHourReminderPreference: TwoHourNotificationPreference?
    private var _currentDayReminderPreference: DayNotificationPreference?
    
    private var _twoHourReminderAlwaysCell: UITableViewCell?
    private var _twoHourReminderOnlyIfAttendingCell: UITableViewCell?
    private var _twoHourReminderNeverCell: UITableViewCell?
    
    private var _dayReminderAlwaysCell: UITableViewCell?
    private var _dayReminderOnlyIfAttendingCell: UITableViewCell?
    private var _dayReminderNeverCell: UITableViewCell?
    
    private var _newLessonAlert: UISwitch?
    
    private func _setTwoHourReminderOptionCell(cell: UITableViewCell, preference: TwoHourNotificationPreference) {
        if _currentTwoHourReminderPreference! == preference {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    private func _setDayReminderOptionCell(cell: UITableViewCell, preference: DayNotificationPreference) {
        if _currentDayReminderPreference! == preference {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        _currentTwoHourReminderPreference = BusinessFactory.providePreference().getTwoHourReminderPreference()
        _currentDayReminderPreference = BusinessFactory.providePreference().getDayReminderPreference()
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
                _twoHourReminderAlwaysCell = cell
                _setTwoHourReminderOptionCell(cell, preference: .Always)
            case 1:
                _twoHourReminderOnlyIfAttendingCell = cell
                _setTwoHourReminderOptionCell(cell, preference: .IfAttending)
            default:
                _twoHourReminderNeverCell = cell
                _setTwoHourReminderOptionCell(cell, preference: .Never)
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                _dayReminderAlwaysCell = cell
                _setDayReminderOptionCell(cell, preference: .Always)
            case 1:
                _dayReminderOnlyIfAttendingCell = cell
                _setDayReminderOptionCell(cell, preference: .IfAttending)
            default:
                _dayReminderNeverCell = cell
                _setDayReminderOptionCell(cell, preference: .Never)
            }
        } else {
            _newLessonAlert = cell.contentView.subviews[0] as? UISwitch
            _newLessonAlert!.on = BusinessFactory.providePreference().getLessonAlertPreference()
            
            _newLessonAlert!.addTarget(self, action: Selector("onNewAlertToggle"), forControlEvents: .ValueChanged)
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            BusinessFactory
                .providePreference()
                .updateTwoHourReminderPreference(TwoHourNotificationPreference(rawValue: indexPath.row)!)
            
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: _currentTwoHourReminderPreference!.rawValue, inSection: 0))!.accessoryType = .None
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        } else if indexPath.section == 1 {
            BusinessFactory
                .providePreference()
                .updateDayReminderPreference(DayNotificationPreference(rawValue: indexPath.row)!)
                    
            tableView.cellForRowAtIndexPath(NSIndexPath(forRow: _currentDayReminderPreference!.rawValue, inSection: 1))!.accessoryType = .None
            tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark
        }
    }
    
    public func onNewAlertToggle() {
        BusinessFactory.providePreference().updateLessonAlertPreference(_newLessonAlert!.on)
    }
}