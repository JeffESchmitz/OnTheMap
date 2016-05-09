//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

// Represents a post of student information returned from the data table via the parse server.
struct StudentInformation {
    
    var objectId: String? 
    var uniqueKey: String? 
    var firstName: String? 
    var lastName: String? 
    var mapString: String? 
    var mediaURL: String? 
    var latitude: Double?
    var longitude: Double?
    var createdAt: String? 
    var updatedAt: String?

    init(dictionary: [String:AnyObject]) {
        objectId    = dictionary[Constants.ParseAPI.ObjectId] as? String
        uniqueKey   = dictionary[Constants.ParseAPI.UniqueKey] as? String
        
        firstName   = dictionary[Constants.ParseAPI.FirstName] as? String
        lastName    = dictionary[Constants.ParseAPI.LastName] as? String
        mapString   = dictionary[Constants.ParseAPI.MapString] as? String
        mediaURL    = dictionary[Constants.ParseAPI.MediaURL] as? String
        latitude    = dictionary[Constants.ParseAPI.Latitude] as? Double
        longitude   = dictionary[Constants.ParseAPI.Longitude] as? Double
        createdAt   = dictionary[Constants.ParseAPI.CreatedAt] as? String
        updatedAt   = dictionary[Constants.ParseAPI.UpdatedAt] as? String
    }
}