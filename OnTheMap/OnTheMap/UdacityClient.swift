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
        print("url: \(url)")
        let jsonBody: [String : AnyObject] = ["udacity" : ["username" : username, "password" : password]]
        print("jsonBody: \(jsonBody)")
     
        taskForPOSTMethod(url, jsonBody: jsonBody) { (result, error) in
            //TODO: JES - 5.1.2016 - refactor below out to common method for FaceBook login to use also

            if error != nil {
                completionHandler(result: false, error: error?.description)
            }
            else {
                guard let account = result[Constants.UdacityAPI.Account] as? [String:AnyObject] else {
                    completionHandler(result: false,
                                      error: "Login Failed. Unable to find \(Constants.UdacityAPI.Account) in json body.")
                    return
                }
                
                guard let registered = account[Constants.UdacityAPI.Registered] as? Bool where registered else {
                    completionHandler(result: false,
                                      error: "Login Failed. Unable to find \(Constants.UdacityAPI.Registered) in json body.")
                    return
                }
                
                // store account key for later
                self.userLogin.accountKey = account[Constants.UdacityAPI.Key] as? String
                
                guard let session = result[Constants.UdacityAPI.Session] as? [String:AnyObject] else {
                    completionHandler(result: false, error: "Login Failed. Unable to find \(Constants.UdacityAPI.Session) in json body.")
                    return
                }
                
                // store session id for later
                self.userLogin.sessionId = session[Constants.UdacityAPI.Id] as? String
                
            }
        }
    }
    
}