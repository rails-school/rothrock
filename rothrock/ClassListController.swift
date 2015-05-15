//
//  ViewController.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit

class ClassListController: UITableViewController {
    private var _slugs: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BusinessFactory
            .provideLesson()
            .sortFutureSlugsByDate(
                {
                    self._slugs = $0
                },
                failure: { (error) in }
            )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = _slugs {
            return s.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let s = _slugs {
            var cell = tableView.dequeueReusableCellWithIdentifier("ClassTableViewCell") as! ClassTableViewCell
            
            cell.hydrate(s[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

