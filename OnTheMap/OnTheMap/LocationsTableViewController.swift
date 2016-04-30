//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

class LocationsTableViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // code here
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // code here...
    }

    func refreshTable() {
        print("refreshTable not implemented yet...")
        // add code to refresh the tableView on this ViewController using GCD.
    }
}

extension LocationsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.studentTableViewCell, forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath not implemented yet...")
    }
    
}
