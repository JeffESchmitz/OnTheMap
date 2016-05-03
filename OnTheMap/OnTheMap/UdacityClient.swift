//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

// Extends the Client class with specific functionality and data related to the Udacity API
extension Client {
    
    func udacityLogin(username: String, password: String, completionHandler: (result: AnyObject, error: String?) -> Void) {
        
        let url = Constants.UdacityAPI.BaseUrl + Constants.UdacityAPI.Methods.Session
        
        let jsonBody: [String : AnyObject] = ["udacity" : ["username" : username, "password" : password]]
     
        taskForPOSTMethod(url, jsonBody: jsonBody) { (result, error) in
            //TODO: JES - 5.1.2016 - refactor below out to common method for FaceBook login to use also
            
            if let error = jsonBody[Constants.UdacityAPI.Error] as? String {
                completionHandler(result: false, error: error)
            }
            else {
                guard let account = jsonBody[Constants.UdacityAPI.Account] as? [String:AnyObject] else {
                    completionHandler(result: false,
                                      error: "Login Failed. Unable to find \(Constants.UdacityAPI.Account) in json body.")
                    return
                }
                
                guard let registered = jsonBody[Constants.UdacityAPI.Registered] as? Bool where registered else {
                    completionHandler(result: false,
                                      error: "Login Failed. Unable to find \(Constants.UdacityAPI.Registered) in json body.")
                    return
                }
                
                // store account key for later
                UserLogin.accountKey = account[Constants.UdacityAPI.Account] as? String
                
                guard let session = jsonBody[Constants.UdacityAPI.Session] as? [String:AnyObject] else {
                    completionHandler(result: false, error: "Login Failed. Unable to find \(Constants.UdacityAPI.Session) in json body.")
                    return
                }
                
                // store session id for later
                UserLogin.sessionId = session[Constants.UdacityAPI.Id] as? String
                
            }
            
            
        }
    }
    
}