//
//  TabBarController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        logoutButton.enabled = false
        
        Client.sharedInstance.logout { (result, error) in
            guard error == nil else {
                self.showAlert(error!)
                self.logoutButton.enabled = true
                return
            }
            
            if let status = result as? Bool where status {
                StudentInformationService.sharedInstance.studentPosts.removeAll()
                dispatch_async(dispatch_get_main_queue(), {
                    self.logoutButton.enabled = true
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    self.logoutButton.enabled = true
                    self.showAlert(error!)
                })
            }
        }
    }
    
    @IBAction func refreshButtonTouched(sender: AnyObject) {
        Client.sharedInstance.getStudentLocations { (result, error) in
            
            if let status = result as? Bool where status {
                if let selectedView = self.selectedViewController as? LocationsTableViewController {
                    selectedView.refreshTable()
                }
                else if let selectedView = self.selectedViewController as? LocationsMapViewController {
                    selectedView.refreshMap()
                }
            }
        }
    }
}
