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
    var DisplayFileName : String
    var AuditActivityBookingAttachments : String
    var UpdatedBy : String
    var UpdatedDate : String
    var Size : Float
    var MIMEType : String
    var UniqueId : String
    var FolderPath : String
    
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
        DisplayFileName = ""
        AuditActivityBookingAttachments = ""
        UpdatedBy = ""
        UpdatedDate = ""
        Size = 0
        MIMEType = ""
        UniqueId = ""
        FolderPath = ""
        UniqueId = ""
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

