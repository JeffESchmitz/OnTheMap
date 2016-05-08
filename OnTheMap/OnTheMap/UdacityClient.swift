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
    
    func udacityLogin(username: String, password: String, completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        let url = Constants.UdacityAPI.BaseUrl + Constants.UdacityAPI.URLPathSeparator + Constants.UdacityAPI.Session
        print("url: \(url)")
        let jsonBody: [String : AnyObject] = ["udacity" : ["username" : username, "password" : password]]
        print("jsonBody: \(jsonBody)")
     
        taskForPOSTMethod(url, jsonBody: jsonBody) { (result, error) in
            //TODO: JES - 5.1.2016 - refactor below out to common method for FaceBook login to use also

            if error != nil {
                completionHandler(result: false, error: error?.valueForKeyPath("userInfo.NSLocalizedDescription") as? String)
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
                
                self.getUdacityUserData(completionHandler)
                
            }
        }
    }
    
    func getUdacityUserData(completionHandler: (result: AnyObject!, error: String?) -> Void) {
     
        let urlString = Constants.UdacityAPI.BaseUrl
                        + Constants.UdacityAPI.URLPathSeparator
                        + Constants.UdacityAPI.Users
                        + Constants.UdacityAPI.URLPathSeparator
                        + userLogin.accountKey!
        print("urlString: \(urlString)")
    
        taskForGETMethod(urlString) { (result, error) in
            if let error = error {
                print("error: \(error)")
                completionHandler(result: false, error: error.valueForKeyPath("userInfo.NSLocalizedDescription") as? String)
            } else {
                guard let user = result[Constants.UdacityAPI.User] as? [String:AnyObject] else {
                    completionHandler(result: false, error: "Udacity user infor not found!")
                    return
                }
                self.userLogin.userFirstName = user[Constants.UdacityAPI.FirstName] as? String
                self.userLogin.userLastName = user[Constants.UdacityAPI.LastName] as? String
                
                completionHandler(result: true, error: "")
            }
        }
    }
    
    func logout(completionHandler: (result: AnyObject!, error: String?) -> Void) {
        if userLogin.loginType == .Udacity {
           let urlString = Constants.UdacityAPI.BaseUrl
                            + Constants.UdacityAPI.URLPathSeparator
                            + Constants.UdacityAPI.Session
            print("urlString: \(urlString)")
            
            taskForDELETEMethod(urlString, completionHandler: { (result, error) in
                
                if error != nil {
                    completionHandler(result: false, error: error?.valueForKeyPath("userInfo.NSLocalizedDescription") as? String)
                }
                else {
                    guard let _ = result[Constants.UdacityAPI.Session] as? [String:AnyObject] else {
                        completionHandler(result: false, error: "Logout Failed!")
                        return
                    }
                    completionHandler(result: true, error: nil)
                }
            })
        }
    }
    
}




















