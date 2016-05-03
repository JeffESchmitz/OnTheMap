//
//  UserLogin.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 5/2/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

struct UserLogin {
    static var accountKey: String?
    static var sessionId: String?
    static var userFirstName: String?
    static var userLastName: String?
    static var loginType: LoginType?
}

enum LoginType {
    case Udacity
    case FaceBook
}