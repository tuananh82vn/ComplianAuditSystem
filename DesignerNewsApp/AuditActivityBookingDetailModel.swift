//
//  AuditActivityBookingDetailModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 3/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation

class AuditActivityBookingDetaiModel : Serializable {
    var Id : Int
    var AuditActivityId : Int
    var AuditActivityUrlId : String
    var Item : String
    var Notes : String
    var FileId : Int
    var FileName : String
    var SerialNumber : Int
    var Attachment : BookingAttachment
    
    override init() {
        Id = 0
        AuditActivityId = 0
        AuditActivityUrlId = ""
        Item = ""
        Notes = ""
        FileId = 0
        FileName = ""
        SerialNumber = 0
        Attachment = BookingAttachment()
    }
}

class BookingAttachment : Serializable {
    var FileName : String
    var ContentType : String
    var Size : Float
    var FileContent : String
    
    
    override init() {
        FileName = ""
        ContentType = ""
        Size = 0
        FileContent = ""
    }
}

