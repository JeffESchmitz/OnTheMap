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
    }
    
    var session: NSURLSession
    
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
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in

            // check for any errors
            guard error == nil else {
                let userInfo = [NSLocalizedDescriptionKey : error!]
                completionHandler(result: nil, error: NSError(domain: #function, code: 1, userInfo: userInfo))
                return
            }
            
            // check what status code returned
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode == 403 else {
                completionHandler(result: nil, error: NSError(domain: #function, code: 2, userInfo: [NSLocalizedDescriptionKey : "Invalid email or password"]))
                return
            }
            
            guard let _ = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                completionHandler(result: nil, error: NSError(domain: #function, code: 2, userInfo: [NSLocalizedDescriptionKey : "Your request returned an invalid status code other than 2xx!"]))
                return
            }
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: #function, code: 3, userInfo: [NSLocalizedDescriptionKey : "No data returned by the request"]))
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