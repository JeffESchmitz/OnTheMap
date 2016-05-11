//
//  StudentInformationService.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

// Exposes and processes StudentInformation throughout the app (mostly used in ViewControllers)
class StudentInformationService {

    static let sharedInstance = StudentInformationService()
    private init(){}
    
    var studentPosts = [StudentInformation]()
    
    func addStudentsFromData(studentInfoDictionaries: [NSDictionary]) {
        
        for studentInfoDictionary in studentInfoDictionaries {
            if let dictionary = studentInfoDictionary as? [String:AnyObject] {
                let studentInfo = StudentInformation(dictionary: dictionary)
                studentPosts.append(studentInfo)
            }
        }
    }    
}