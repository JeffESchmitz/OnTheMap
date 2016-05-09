//
//  Client.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

class Client {
    
    static let sharedInstance = Client()
    private init(){
        session = NSURLSession.sharedSession()
        userLogin = UserLogin()
    }
    
    var session: NSURLSession
//    var userLoginType: LoginType?
    var userLogin: UserLogin
    
    func taskForPOSTMethod(urlString: String,
                           jsonBody: [String: AnyObject],
                           completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        guard let url = NSURL(string: urlString) else {
            print("url failed to initialize with '\(urlString)'")
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = Constants.HttpRequest.MethodPOST
        request.addValue(Constants.HttpRequest.ContentJSON, forHTTPHeaderField: Constants.HttpRequest.AcceptHeaderField)
        request.addValue(Constants.HttpRequest.ContentJSON, forHTTPHeaderField: Constants.HttpRequest.ContentTypeHeaderField)
        do {
            print("jsonBody: \(jsonBody)")
            let requestBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            print("HTTPBody: '\(requestBody)'")
            request.HTTPBody = requestBody
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            // Check for any errors
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // Successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // Any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Udactiy API Special Note!
            // "FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE."
            var newData = data
            if urlString.containsString("udacity.com") {
                newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
            }
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
        }
        task.resume()
    }
    
//    func taskForGETMethod(urlString: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
    func taskForGETMethod(urlString: String,
                          requestHeaders: [String:String]? = nil,
                          completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
    
        func sendError(error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(result: nil, error: NSError(domain: "taskForGETMethod", code: 2, userInfo: userInfo))
        }
        
        // 1. Build the request
        guard let url = NSURL(string: urlString) else {
            sendError("Invalid URL or nil")
            return
        }
        let request = NSMutableURLRequest(URL: url)
        if let headers = requestHeaders {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            // Check for any errors
            guard error == nil else {
                sendError("Error submitting request to the server. request: '\(request)'")
                return
            }
            
            // Successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // Any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Udactiy API Special Note!
            // "FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE."
            var newData = data
            if urlString.containsString("udacity.com") {
                newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
            }

            // 3. Parse and use the data in completionHandler
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
            
        }
        // 2. Submit the request
        task.resume()
    }
    
    func taskForDELETEMethod(urlString: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        print("urlString: \(urlString)")
        func sendError(error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandler(result: nil, error: NSError(domain: "taskForDELETEMethod", code: 3, userInfo: userInfo))
        }
        
        // 1. Build the request
        guard let url = NSURL(string: urlString) else {
            sendError("Invalid URL or nil")
            return
        }
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = Constants.HttpRequest.MethodDELETE
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.HttpRequest.CookieName {
                xsrfCookie = cookie
            }
        }

        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.HttpRequest.XSRFHeaderField)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // Check for any errors
            guard error == nil else {
                sendError("Error submitting request to the server. request: '\(request)'")
                return
            }
            
            // Successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // Any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            var newData = data
            if urlString.containsString("udacity.com") {
                newData = data.subdataWithRange(NSMakeRange(5, (data.length) - 5))
            }
            
            // 3. Parse and use the data in completionHandler
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandler)
        }
        task.resume()
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
}












