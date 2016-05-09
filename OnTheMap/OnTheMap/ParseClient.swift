//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

// Extends the Client class with specific functionality and data related to the Parse API
extension Client {
    
    func getStudentLocations(completionHandler: (result: AnyObject!, error: String?) -> Void) {
        
        let parameters = [
            Constants.ParseAPI.Limit : Constants.ParseAPI.OneHundred,
            Constants.ParseAPI.Order : Constants.ParseAPI.AscUpdatedAt
        ]
        let requestHeaders = [
            Constants.ParseAPI.HeaderAppId : Constants.ParseAPI.ApplicationId,
            Constants.ParseAPI.HeaderAPIKey : Constants.ParseAPI.RESTAPIKey
        ]
        
        let urlString = Constants.ParseAPI.BaseUrl + Constants.ParseAPI.GetStudentLocationsMethod + converParametersDictionaryToString(parameters)
        print("urlString: \(urlString)")
        
        taskForGETMethod(urlString, requestHeaders: requestHeaders) { (result, error) in
            if let error = error {
                print("error: \(error)")
                completionHandler(result: false, error: error.valueForKeyPath("userInfo.NSLocalizedDescription") as? String)
            }
            else {
                guard let results = result[Constants.ParseAPI.Results] as? [[String:AnyObject]] else {
                    completionHandler(result: false, error: "Student results nil or empty")
                    return
                }
                StudentInformationService.sharedInstance.addStudentsFromData(results)
                
                // signal back to caller that all is good!
                completionHandler(result: true, error: "")
            }
        }
    }
    
    
    func converParametersDictionaryToString(parameters: [String: AnyObject]) -> String {
        var result = ""
        
        for (key, value) in parameters {
            guard let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
                print("Error returning escaped string value.")
                return result
            }
            result += key + "=" + escapedValue + "&"
        }
        if !result.isEmpty {
            if result.characters.last! == "&" {
                result.removeAtIndex(result.endIndex.predecessor())
            }
            result.insert("?", atIndex: result.startIndex)
        }
        print("result: \(result)")
        return result
    }
}