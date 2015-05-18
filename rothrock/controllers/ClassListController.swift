//
//  ViewController.swift
//  rothrock
//
//  Created by Adrien on 23/04/15.
//  Copyright (c) 2015 RailsSchool. All rights reserved.
//

import UIKit

class ClassListController: BaseController, UITableViewDelegate, UITableViewDataSource {
    private var _slugs: [String]?
    
    @IBOutlet weak var _list: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _list.rowHeight = UITableViewAutomaticDimension
        _list.estimatedRowHeight = 300.0
        BusinessFactory
            .provideLesson()
            .sortFutureSlugsByDate(
                {
                    self._slugs = $0
                    self._list.reloadData()
                },
                failure: { (error) in }
            )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prepareToUnwind(sender: UIStoryboardSegue) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let s = _slugs {
            return s.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let s = _slugs {
            var cell: ClassTableViewCell? = tableView.dequeueReusableCellWithIdentifier("ClassTableViewCell") as! ClassTableViewCell?
            
            if cell == nil {
                cell = NSBundle.mainBundle().loadNibNamed("ClassTableViewCell", owner: self, options: nil)[0] as? ClassTableViewCell
            }
            
            cell!.hydrate(s[indexPath.row])
            
            return cell!
        } else {
            return UITableViewCell()
        }
    }
}

