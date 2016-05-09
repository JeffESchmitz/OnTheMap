//
//  Constants.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

// MARK: Constants accross all clients
struct Constants {
    
    // LoginViewController constants
    static let emailEmptyMessage = "Please enter an Email Address"
    static let passwordEmptyMessage = "Please enter a Password"
    
    // TabBarViewController constants
    
    // LocationsMapViewController constants

    // LocationsTableViewController constants
    static let studentTableViewCell = "StudentTableViewCell"

    // InformationPostingViewController constants
    
    
    struct HttpRequest {
        static let MethodPOST               = "POST"
        static let AcceptHeaderField        = "Accept"
        static let ContentTypeHeaderField   = "Content-Type"
        static let ContentJSON              = "application/json"

        static let MethodDELETE             = "DELETE"
        static let CookieName               = "XSRF-TOKEN"
        static let XSRFHeaderField          = "X-XSRF-TOKEN"
        
    }
    
    struct UdacityAPI {
        static let BaseUrl                  = "https://www.udacity.com/api"
        static let SignUpUrl                = "https://www.udacity.com/account/auth#!/signin"

        static let URLPathSeparator         = "/"
        static let Error                    = "error"
        static let Account                  = "account"
        static let Registered               = "registered"
        static let Session                  = "session"
        static let Users                    = "users"
        
        static let Id                       = "id"
        static let Key                      = "key"
        static let User                     = "user"
        static let FirstName                = "first_name"
        static let LastName                 = "last_name"
        
    }
    
    struct ParseAPI {
        static let BaseUrl                  = "https://api.parse.com/"
        static let GetStudentLocationsMethod = "1/classes/StudentLocation"
        
        static let Limit                    = "limit"
        static let OneHundred               = "100"
        static let Order                    = "order"
        static let AscUpdatedAt             = "-updatedAt"
        static let HeaderAppId              = "X-Parse-Application-Id"
        static let ApplicationId            = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let HeaderAPIKey             = "X-Parse-REST-API-Key"
        static let RESTAPIKey               = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let Results                  = "results"
        
        static let ObjectId                 = "objectId"
        static let UniqueKey                = "uniqueKey"
        static let FirstName                = "firstName"
        static let LastName                 = "lastName"
        static let MapString                = "mapString"
        static let MediaURL                 = "mediaURL"
        static let Latitude                 = "latitude"
        static let Longitude                = "longitude"
        static let CreatedAt                = "createdAt"
        static let UpdatedAt                = "updatedAt"
        
        
    }

}

