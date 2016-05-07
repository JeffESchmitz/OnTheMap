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
        static let MethodPOST           = "POST"
        static let AcceptHeaderField    = "Accept"
        static let ContentTypeHeaderField    = "Content-Type"
        static let ContentJSON          = "application/json"
        
    }
    
    struct UdacityAPI {
        static let BaseUrl: String = "https://www.udacity.com/api"
        static let Error: String = "error"
        static let Account: String = "account"
        static let Registered: String = "registered"
        static let Session: String = "session"
        static let Id: String = "id"
        static let Key: String = "key"
        static let User: String = "user"
        static let FirstName: String = "first_name"
        static let LastName: String = "last_name"
        
        
        
        struct Methods {
            static let Session: String = "/session"
            static let Users:   String = "/users"
            
        }
    }

    
}

