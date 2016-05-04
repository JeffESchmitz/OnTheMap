//
//  UserLogin.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 5/2/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation

struct UserLogin {
    var accountKey: String?
    var sessionId: String?
    var userFirstName: String?
    var userLastName: String?
    var loginType: LoginType?
}

enum LoginType {
    case Udacity
    case FaceBook
}