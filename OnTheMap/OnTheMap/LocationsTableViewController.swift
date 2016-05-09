//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

class LocationsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Bit of a hack (but works) fix to remove the trailing empty cells from the UITableView - http://stackoverflow.com/questions/28708574/how-to-remove-extra-empty-cells-in-tableviewcontroller-ios-swift
        tableView.tableFooterView = UIView()
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshTable()
    }
    
    

    func refreshTable() {
        print("refreshTable not implemented yet...")
        // add code to refresh the tableView on this ViewController using GCD.
        Client.sharedInstance.getStudentLocations { (result, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if let status = result as? Bool where status {
                    self.tableView.reloadData()
                } else {
                    print("error: \(error)")
                    self.showAlert(error)
                }
            })
        }
    }
}

extension LocationsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfPosts = StudentInformationService.sharedInstance.studentPosts.count
        print("numberOfPosts: \(numberOfPosts)")
        return numberOfPosts
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.studentTableViewCell, forIndexPath: indexPath) as! StudentTableViewCell
        
        let studentInfo = StudentInformationService.sharedInstance.studentPosts[indexPath.row]
        cell.studentNameLabel.text = "\(studentInfo.firstName!) \(studentInfo.lastName!)"
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath not implemented yet...")
    }
    
}
