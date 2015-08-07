//
//  AuditActivityMeetingModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityMeetingModel : Serializable {
    
    var AuditActivityId : Int
    var UrlId : String
    var LeadAuditor : String
    var SiteName : String
    var OpenMeetingDateDisplay : String
    var CloseMeetingDateDisplay : String
    var OpenMeetingDate : String
    var CloseMeetingDate : String
    
    override init() {
        AuditActivityId = 0
        UrlId = ""
        LeadAuditor = ""
        SiteName = ""
        OpenMeetingDateDisplay = ""
        CloseMeetingDateDisplay = ""
        OpenMeetingDate = ""
        CloseMeetingDate = ""
    }
}

class AuditActivityMeetingAttendanceRecordModel : Serializable {
    
    var Id : Int
    var AuditActivityId : Int
    var Name : String
    var Position : String
    var SignOpenMeeting : String
    var SignCloseMeeting : String
    var SerialNumber : Int
    var AuditActivityUrlId : String

    
    override init() {
        Id = 0
        AuditActivityId = 0
        Name = ""
        Position = ""
        SignOpenMeeting = ""
        SignCloseMeeting = ""
        SerialNumber = 0
        AuditActivityUrlId = ""
        
    }
}