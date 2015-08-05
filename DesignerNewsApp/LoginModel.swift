//
//  LoginModel.swift
//  ComplianceAuditSystem
//
//  Created by synotivemac on 13/07/2015.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation


class LoginModel : Serializable {
    var Name: String
    var AuditorCompanyName : String
    var TokenNumber: String
    var UserName: String
    var PreferName: String
    var EmailAddress: String
    var Mobile: String
    var JobTitle: String
    var PhotoId: Int
    var AuditorCompanyAddress : String
    var UserId: Int
    var AuditorCompanySuburb : String
    var AuditorCompanyPostcode : String
    var Initials : String
    var Phone : String
    var RoleId : Int
    var AuditorCompanyStateName : String
    
    override init() {
        Name = ""
        AuditorCompanyName = ""
        TokenNumber = ""
        UserName = ""
        PreferName = ""
        EmailAddress = ""
        Mobile = ""
        JobTitle = ""
        PhotoId = 0
        AuditorCompanyAddress = ""
        UserId = 0
        AuditorCompanySuburb = ""
        AuditorCompanyPostcode = ""
        Initials = ""
        Phone = ""
        RoleId = 0
        AuditorCompanyStateName = ""
        
    }
}

