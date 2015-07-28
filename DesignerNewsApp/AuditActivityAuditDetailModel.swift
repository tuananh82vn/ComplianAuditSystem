//
//  AuditActivityAuditDetail.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityAuditDetailModel : Serializable {
    
    var AuditType : String
    var EmailAddress : String
    var AuditActivityId : Int
    var CanEdit : Bool
    var UrlId : String
    var AuditTypeId : Int
    var Phone: String
    var AuditEndDateDisplay: String
    var TimeOnFactoryFloor: [AuditActivityDayModel?]
    var TimeOnSite: [AuditActivityDayModel?]
    var AuditActivityDayListJson: String
    var AuditActivityStatusColor: String
    var ScopeOfAudit: String
    var AuditActivityStatusName: String
    var CanApprove: Bool
    var AuditRequestId: Int
    var AuditStartDate : NSDate?
    var AuditActivityStatusId : Int?
    var LeadAuditor : String
    var AuditStartDateDisplay : String
    var AuditEndDate : NSDate?
    var ReportId : Int?
    
    override init() {
        AuditType = ""
        EmailAddress = ""
        AuditActivityId = 0
        CanEdit = false
        UrlId = ""
        AuditTypeId = 0
        Phone = ""
        AuditEndDateDisplay = ""
        AuditActivityStatusColor = ""
        ScopeOfAudit = ""
        AuditActivityStatusName = ""
        CanApprove = false
        AuditRequestId = 0
        AuditStartDate = nil
        AuditActivityStatusId = nil
        LeadAuditor = ""
        AuditStartDateDisplay = ""
        AuditEndDate = nil
        ReportId = nil
        TimeOnFactoryFloor = [AuditActivityDayModel]()
        TimeOnSite = [AuditActivityDayModel]()
        AuditActivityDayListJson =  ""
    }
}

class AuditActivityDayModel : Serializable {
    var DayNumber : Int
    var DayType : Int
    var DayDateDisplay : String
    var DayDate : String
    
    override init() {
        DayNumber = 0
        DayType = 0
        DayDateDisplay = ""
        DayDate = ""
    }
}
