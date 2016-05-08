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
    
    
    @IBAction func logoutButtonTouched(sender: AnyObject) {
        
        Client.sharedInstance.logout { (result, error) in
            guard error == nil else {
                self.showAlert(error!)
                return
            }
            
            if let status = result as? Bool where status {
                StudentInformationService.sharedInstance.studentPosts.removeAll()
                dispatch_async(dispatch_get_main_queue(), { 
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
}
