//
//  AuditActivitySiteDetailModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivitySiteDetailModel {
    var AuditRequestSiteId : Int
    var SiteName : String
    var SiteCompanyName : String
    var SiteIndustryTypeName :String
    var SiteTypeName : String
    var SiteAddress : String
    var SiteSuburb: String
    var SiteState: String
    var StateName: String
    var SitePostCode: String
    var SiteContactPerson: String
    var SiteContactPosition: String
    var SiteContactEmail: String
    var SiteContactPhone: String
    var SiteAlternateContactPerson : String
    var SiteAlternateContactPosition : String
    var SiteAlternateContactEmail : String
    var SiteAlternateContactPhone : String
    var AuditActivityUrlId : String
    var SiteUrlId : String
    
    init() {
         AuditRequestSiteId = 0
         SiteName = ""
         SiteCompanyName = ""
         SiteIndustryTypeName = ""
         SiteTypeName = ""
         SiteAddress = ""
         SiteSuburb = ""
         SiteState = ""
         StateName = ""
         SitePostCode = ""
         SiteContactPerson = ""
         SiteContactPosition =  ""
         SiteContactEmail = ""
         SiteContactPhone = ""
         SiteAlternateContactPerson = ""
         SiteAlternateContactPosition = ""
         SiteAlternateContactEmail = ""
         SiteAlternateContactPhone = ""
         AuditActivityUrlId = ""
         SiteUrlId = ""
    }
}