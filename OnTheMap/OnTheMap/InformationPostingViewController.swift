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
    
//    var activityViewController = ActivityViewController()
    private var coordinate: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // code here...
    }
    
    @IBAction func findButtonTouched(sender: AnyObject) {
        findFunctionVersion1()
        
//        findFunctionVersion2()
    }
    
    func findFunctionVersion2() {
        
        // check if the location to be searched is empty or not
        guard !locationTextField.text!.isEmpty else {
            showAlert("Please enter some location")
            return
        }
        
        LoadingOverlay.shared.showOverlay(self.view, message: "Locating...")
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            
            LoadingOverlay.shared.hideOverlayView()
            
            if error != nil {
                self.showAlert(error?.description)
                
            } else {
                
                // get the first location of the array
                if let placemark = placemarks?.first {
                    
                    self.coordinate = placemark.location!.coordinate
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                    // center this position
                    self.mapView.centerCoordinate = self.coordinate!
                    
                    // zoom in the map to focus on the found coordinates
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.coordinate!, 1000 * 2.0, 1000 * 2.0)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                    
                    // Hide/Show UI elements
                    self.whereStudyingLabel.text = "Add a URL to your post"
                    self.locationTextField.hidden = true
                    self.findOnMapButton.hidden = true
                    self.urlTextField.hidden = false
                    self.urlTextField.enabled = true
                    
                } else {
                    self.showAlert("Failed to find location")
                }
            }
        }

    }
    
    func findFunctionVersion1() {
        guard let whereabouts = locationTextField.text
            where !whereabouts.isEmpty else {
                self.showAlert("Please enter a location")
                return
        }
        
        LoadingOverlay.shared.showOverlay(self.view, message: "Locating...")
        
        CLGeocoder().geocodeAddressString(whereabouts) { (placemarks, error) in
            
            LoadingOverlay.shared.hideOverlayView()
            
            guard error == nil else {
                self.showAlert("Geocoding the map failed")
                return
            }
            
            guard let placemarks = placemarks else {
                LoadingOverlay.shared.hideOverlayView()
                self.showAlert("Dude, no map placements were returned...")
                return
            }
            
            let placemark = placemarks.first
            self.coordinate = placemark?.location?.coordinate
            if let placemark = placemark {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
            
            // center the map
            guard let unwrappedCoordinate = self.coordinate else {
                LoadingOverlay.shared.hideOverlayView()
                self.showAlert("Failed to retrieve coordinates")
                return
            }
            
            // set the zoom focus
            let latitudeDelta = CLLocationDegrees(floatLiteral: 0.001)
            let longitudDelta = CLLocationDegrees(floatLiteral: 0.001)
            let coordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudDelta)
            let region = MKCoordinateRegionMake(unwrappedCoordinate, coordinateSpan)
            self.mapView.setRegion(region, animated: true)
            
            // Hide/Show UI elements
            self.whereStudyingLabel.text = "Add a URL to your post"
            self.locationTextField.hidden = true
            self.findOnMapButton.hidden = true
            self.urlTextField.hidden = false
            self.urlTextField.enabled = true
            
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
