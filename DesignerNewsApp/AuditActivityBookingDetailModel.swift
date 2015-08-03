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
    var Item : String
    var Notes : String
    var FileId : Int
    var FileName : String
    var SerialNumber : Int

    
    override init() {
        Id = 0
        AuditActivityId = 0
        Item = ""
        Notes = ""
        FileId = 0
        FileName = ""
        SerialNumber = 0
    }
}
