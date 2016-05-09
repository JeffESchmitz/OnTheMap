//
//  LocationsMapViewController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    // List of Map Annotations
    var annotations: [MKPointAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        annotations = [MKPointAnnotation]()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        Client.sharedInstance.getStudentLocations { (result, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if let status = result as? Bool where status {
                    self.refreshMap()
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert(error!)
                    })
                }
            })
        }
    }
    
    func refreshMap() -> Void {
        
        getAnnotations()

        if let annotations = self.annotations {
            dispatch_async(dispatch_get_main_queue()) {
                self.mapView.addAnnotations(annotations)
            }
        }
    }

    private func getAnnotations() {
        let studentPosts = StudentInformationService.sharedInstance.studentPosts
        for studentInfo in studentPosts {
            let lat = CLLocationDegrees(studentInfo.latitude!)
            let long = CLLocationDegrees(studentInfo.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let firstName = studentInfo.firstName
            let lastName = studentInfo.lastName
            let mediaURL = studentInfo.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName!) \(lastName!)"
            annotation.subtitle = mediaURL
            
            annotations!.append(annotation)

        }
    }
}

extension LocationsMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "StudentPin"
        
        guard let pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView else {
            let newPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            newPinView.canShowCallout = true
            newPinView.pinTintColor = UIColor.redColor()
            newPinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            return newPinView
        }
        
        pinView.annotation = annotation
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                if let url = NSURL(string: toOpen) {
                    if !UIApplication.sharedApplication().openURL(url){
                        self.showAlert("Invalid URL")
                    }
                }
            }
        }
    }
}