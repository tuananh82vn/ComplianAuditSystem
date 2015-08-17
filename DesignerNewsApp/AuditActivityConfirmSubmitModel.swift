//
//  AuditActivityConfirmSubmitModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 14/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityConfirmSubmitModel : Serializable {
    
    var Id : Int
    var AuditActivityStatusId : Int
    var AuditType : Int
    var UrlId : String
    var CanEdit : Bool
    var CanApprove : Bool
    var IsAuditDetailsCompleted : Bool
    var IsBookingDetailsCompleted : Bool
    var IsAuditPlanCompleted : Bool
    var IsMeetingAttendanceRecordCompleted : Bool
    var IsQuestionSetCompleted : Bool
    var IsAuditDetailsCompletedstring : String
    var IsBookingDetailsCompletedstring : String
    var IsAuditPlanCompletedstring : String
    var IsMeetingAttendanceRecordCompletedstring : String
    var IsQuestionSetCompletedstring : String
    var Notes : String
    var AuditOutcomeId : Int
    var AuditOutcomeName : String
    var AuditOutcomeColorName : String
    
    override init() {
         Id = 0
         AuditActivityStatusId = 0
         AuditType = 0
         UrlId = ""
         CanEdit = false
         CanApprove = false
         IsAuditDetailsCompleted = false
         IsBookingDetailsCompleted = false
         IsAuditPlanCompleted = false
         IsMeetingAttendanceRecordCompleted = false
         IsQuestionSetCompleted = false
         IsAuditDetailsCompletedstring = ""
         IsBookingDetailsCompletedstring = ""
         IsAuditPlanCompletedstring = ""
         IsMeetingAttendanceRecordCompletedstring = ""
         IsQuestionSetCompletedstring = ""
         Notes = ""
         AuditOutcomeId = 0
         AuditOutcomeName = ""
         AuditOutcomeColorName = ""

    }
}

class AuditActivityHistoryModel : Serializable {
    
    var AuditActivityStatusId : Int
    var PhotoId : Int
    var UserName : String
    var AuditActivityStatusName : String
    var AuditActivityStatusColor : String
    var Comment : String
    var CreatedDate : String
    var CreatedDateDisplay : String
    
    override init() {
        AuditActivityStatusId = 0
        PhotoId = 0
        UserName = ""
        AuditActivityStatusName = ""
        AuditActivityStatusColor = ""
        Comment = ""
        CreatedDate = ""
        CreatedDateDisplay = ""
    }
}