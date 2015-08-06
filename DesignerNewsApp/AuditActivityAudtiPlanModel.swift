//
//  AuditActivityAudtiPlanModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 6/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityAuditPlanModel : Serializable {

    var AuditActivityDayId : Int
    var AuditActivityId : Int
    var DayType : Int
    var AuditActivityAuditPlanId : Int
    var DayNumber : Int
    var DayDate : String
    var TimeText : String
    var Activity : String
    var ResoucesRequired : String
    var DayDateDsiplay : String
    var DayTypeName : String
    
    override init() {
        AuditActivityDayId = 0
        AuditActivityId = 0
        DayType = 0
        AuditActivityAuditPlanId = 0
        DayNumber = 0
        DayDate = ""
        TimeText = ""
        Activity = ""
        ResoucesRequired = ""
        DayDateDsiplay = ""
        DayTypeName = ""
    }
}

class AuditPlanMasterModel : Serializable {
    var DayNumber : Int
    var DayTypeName : String
    var DayDateDisplay : String
    var AuditActivityDayId : Int
    
    override init() {
        DayNumber = 0
        DayTypeName = ""
        DayDateDisplay = ""
        AuditActivityDayId = 0
    }
}

class AuditPlanDetailModel : Serializable {
    var TimeText : String
    var Activity : String
    var ResoucesRequired : String
    var AuditActivityDayId : Int
    
    override init() {
        TimeText = ""
        Activity = ""
        ResoucesRequired = ""
        AuditActivityDayId = 0
    }
}