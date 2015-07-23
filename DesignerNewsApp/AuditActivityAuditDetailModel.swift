//
//  AuditActivityAuditDetail.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityAuditDetailModel {
    
    var AuditType : String
    var EmailAddress : String
    var AuditActivityId : Int
    var CanEdit : Bool
    var UrlId : String
    var AuditTypeId : Int
    var Phone: String
    var AuditEndDateDisplay: String
    var ListAuditActivityDay: [AuditActivityDayModel]
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
    
    init() {
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
        ListAuditActivityDay = [AuditActivityDayModel]()
    }
}

class AuditActivityDayModel {
    var DayNumber : Int
    var DayType : Int
    var DayDateDisplay : String
    
    init() {
        DayNumber = 0
        DayType = 0
        DayDateDisplay = ""
    }
}
