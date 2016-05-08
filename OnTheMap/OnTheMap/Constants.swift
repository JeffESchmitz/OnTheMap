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

    
}

