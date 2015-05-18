//
//  AccountSettingsController.swift
//  rothrock
//
//  Created by Adrien on 17/05/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import Foundation
import UIKit
import SwiftEventBus

public class AccountSettingsController: BaseController, UITableViewDelegate {
    
    private var _isProcessingCredentials = false
    
    private var _emailField: UITextField?
    private var _passwordField: UITextField?
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil && segue.identifier! == "Embed" {
            var controller = segue.destinationViewController as! UITableViewController
            var tableView = controller.view as! UITableView
            
            tableView.delegate = self
        }
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            _emailField = cell.contentView.subviews[0] as? UITextField
        } else {
            _passwordField = cell.contentView.subviews[0] as? UITextField
        }
    }
    
    @IBAction func onSave(sender: AnyObject) {
        if _isProcessingCredentials {
            return
        }
        
        _isProcessingCredentials = true
        SwiftEventBus.post(InformationEvent.NAME, sender: InformationEvent(message: "processing".localized))
        
        BusinessFactory
            .provideUser()
            .checkCredentials(
                _emailField!.text,
                password: _passwordField!.text,
                success: {
                    SwiftEventBus.post(ConfirmationEvent.NAME, sender: ConfirmationEvent(message: "saved_confirmation".localized))
                    self._isProcessingCredentials = false
                    self.dismissViewControllerAnimated(true, completion: nil)
                },
                failure: {
                    self.publishError($0)
                    self._isProcessingCredentials = false
                }
        )
    }
}