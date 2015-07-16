//
//  AuditActivityModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditRequestModel {
    
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
    
//    init(Id : Int,
//         UrlId : String,
//         SiteId :Int?,
//         AuditCompanyId : Int?,
//         AuditorId : Int?,
//         SiteName  :String,
//         Address: String,
//         Suburb: String,
//         StateName: String,
//         PostCode: String,
//         AuditorName: String,
//         AuditCompanyName: String,
//         QuestionSetName: String,
//         QuestionSetUrlId: String,
//         RequestFromDate : NSDate?,
//         RequestFromDateDisplay : String,
//         RequestToDate :NSDate?,
//         RequestToDateDisplay : String,
//         AcceptedFromDate : NSDate?,
//         AcceptedFromDateDisplay : String,
//         AcceptedToDate : NSDate?,
//         AcceptedToDateDisplay : String,
//         AuditRequestStatusId: Int?,
//         CanStartAudit :Bool,
//         AuditActivityId: Int?,
//         AuditActivityUrlId: String,
//         AuditActivityStatusId : Int?,
//         CanEditAuditActivity : Bool) {
//            self.Id = Id
//            self.UrlId = UrlId
//            self.SiteId = SiteId
//            self.AuditCompanyId = AuditCompanyId
//            self.AuditorId = AuditorId
//            self.SiteName  = SiteName
//            self.Address =  Address
//            self.Suburb = Suburb
//            self.StateName =  StateName
//            self.PostCode = PostCode
//            self.AuditorName = AuditorName
//            self.AuditCompanyName = AuditCompanyName
//            self.QuestionSetName = QuestionSetName
//            self.QuestionSetUrlId = QuestionSetUrlId
//            self.RequestFromDate = RequestFromDate
//            self.RequestFromDateDisplay = RequestFromDateDisplay
//            self.RequestToDate = RequestToDate
//            self.RequestToDateDisplay = RequestToDateDisplay
//            self.AcceptedFromDate = AcceptedFromDate
//            self.AcceptedFromDateDisplay = AcceptedFromDateDisplay
//            self.AcceptedToDate = AcceptedToDate
//            self.AcceptedToDateDisplay = AcceptedToDateDisplay
//            self.AuditRequestStatusId = AuditRequestStatusId
//            self.CanStartAudit = CanStartAudit
//            self.AuditActivityId = AuditActivityId
//            self.AuditActivityUrlId = AuditActivityUrlId
//            self.AuditActivityStatusId = AuditActivityStatusId
//            self.CanEditAuditActivity = CanEditAuditActivity
//    }
}