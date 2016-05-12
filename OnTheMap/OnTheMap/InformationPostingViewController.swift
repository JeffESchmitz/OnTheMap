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

    @IBOutlet weak var locationTextField: UITextField! {
        didSet { locationTextField.delegate = self }
    }
    @IBOutlet weak var urlTextField: UITextField! {
        didSet { urlTextField.delegate = self }
    }
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var whereStudyingLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    private var coordinate: CLLocationCoordinate2D?
    
    @IBAction func findButtonTouched(sender: AnyObject) {
        findFunctionVersion()
    }
    
    func findFunctionVersion() {
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
            
            self.findOnMapButton.enabled = false
            self.findOnMapButton.hidden = true
            
            self.urlTextField.hidden = false
            self.urlTextField.enabled = true
            
            self.submitButton.hidden = false
            self.submitButton.enabled = true

        }
    }
    
    @IBAction func submitButtonTouched(sender: AnyObject) {
        print("submitButtonTouched")
        
        LoadingOverlay.shared.showOverlay(view, message: "Posting...")
        
        let studentInfoDictionary = [
            Constants.ParseAPI.ObjectId: "",
            Constants.ParseAPI.UniqueKey: Client.sharedInstance.userLogin.accountKey!,
            Constants.ParseAPI.FirstName: Client.sharedInstance.userLogin.userFirstName!,
            Constants.ParseAPI.LastName: Client.sharedInstance.userLogin.userLastName!,
            Constants.ParseAPI.MapString: locationTextField.text!,
            Constants.ParseAPI.MediaURL: urlTextField.text!,
            Constants.ParseAPI.CreatedAt: "",
            Constants.ParseAPI.UpdatedAt: "",
            Constants.ParseAPI.Latitude: coordinate!.latitude,
            Constants.ParseAPI.Longitude: self.coordinate!.longitude
        ]
        print("studentInfoDictionary: \(studentInfoDictionary)")

        let studentInformation = StudentInformation(dictionary: studentInfoDictionary as! [String:AnyObject])
        print("studentInformation: \(studentInformation)")

        Client.sharedInstance.postStudentInformation(studentInformation) { (result, error) in

            dispatch_async(dispatch_get_main_queue(), { 
                LoadingOverlay.shared.hideOverlayView()
            })
            
            if error != nil {
                self.showAlert(error!)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { 
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}