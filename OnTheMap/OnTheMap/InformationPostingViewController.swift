//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var whereStudyingLabel: UILabel!
    
    private let activityViewController = ActivityViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // code here...
    }
    
    @IBAction func findButtonTouched(sender: AnyObject) {
        
        
        activityViewController.displayMessage = "Locating..."
        presentViewController(activityViewController, animated: true, completion: nil)
        
        
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                self.activityViewController.dismissActivity()
                
                self.whereStudyingLabel.text = "Add a URL to your post"
                self.locationTextField.hidden = true
                self.locationTextField.enabled = false
                self.urlTextField.hidden = false
                self.urlTextField.enabled = true

            }

        }
        
        

        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
