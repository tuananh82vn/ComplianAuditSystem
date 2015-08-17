//
//  AuditActivityModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


struct AuditRequestModelList {

    let Items : [AuditRequestModel]
    let Total : Int
    let IsSuccess : Bool
    let Error : String
}


class AuditRequestModel {
    var TotalRows : Int
    var Id : Int
    var UrlId : String
    var SiteId :Int?
    var AuditCompanyId : Int?
    var AuditorId : Int?
    var SiteName  :String
    var Address: String
    var Suburb: String
    var StateName: String
    var PostCode: String
    var AuditorName: String
    var AuditCompanyName: String
    var QuestionSetName: String
    var QuestionSetUrlId: String
    var RequestFromDate : NSDate?
    var RequestFromDateDisplay : String
    var RequestToDate : NSDate?
    var RequestToDateDisplay : String
    var AcceptedFromDate : NSDate?
    var AcceptedFromDateDisplay : String
    var AcceptedToDate : NSDate?
    var AcceptedToDateDisplay : String
    var AuditRequestStatusId: Int?
    var CanStartAudit : Bool
    var AuditActivityId: Int?
    var AuditActivityUrlId: String
    var AuditActivityStatusId : Int?
    var CanEditAuditActivity : Bool
    
    init() {
        TotalRows = 0
        Id = 0
        UrlId = ""
        SiteId = 0
         AuditCompanyId = 0
         AuditorId = 0
         SiteName  = ""
         Address = ""
         Suburb = ""
         StateName = ""
         PostCode = ""
         AuditorName = ""
         AuditCompanyName = ""
         QuestionSetName = ""
         QuestionSetUrlId = ""
         RequestFromDate  = NSDate()
         RequestFromDateDisplay = ""
         RequestToDate = NSDate()
         RequestToDateDisplay = ""
         AcceptedFromDate = NSDate()
         AcceptedFromDateDisplay = ""
         AcceptedToDate = NSDate()
         AcceptedToDateDisplay = ""
         AuditRequestStatusId = 0
         CanStartAudit = false
         AuditActivityId = 0
         AuditActivityUrlId = ""
         AuditActivityStatusId = 0
         CanEditAuditActivity = false
    }
}

struct AuditRequestStatusModelList {
    
    let Item : [AuditRequestStatusModel]
    let IsSuccess : Bool
    let Error : String
}

class AuditRequestStatusModel {
    var Id : Int?
    var Name : String
    var Color : String
    var Description : String
    var DisplayOrder: Int
    var MainStatus : Int
    init() {
        Id = 0
        Name = ""
        Color = ""
        Description = ""
        DisplayOrder = 0
        MainStatus = 0
    }
}

class AuditRequestFilter {
    var Page : Int
    var PageSize : Int
    var Sort : String
    var SiteName : String
    var Status : String
    var FromDate : NSDate?
    var ToDate : NSDate?
    
    init() {
      Page = 1
      PageSize = 20
      Sort = "SiteName-asc"
      SiteName = ""
      Status = ""
      FromDate = nil
      ToDate = nil
    }
}

class AuditRequestStartAuditModel {
    var AuditActivityId : Int?
    var AuditActivityUrlId : String
    init() {
        AuditActivityId = 0
        AuditActivityUrlId = ""
    }
}

