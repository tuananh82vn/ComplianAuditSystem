//
//  AuditActivityQuestionSetModel.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 10/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import Foundation


class AuditActivityQuestionSetModel : Serializable {
    
    var AuditActivityQuestionSetId : Int
    var AuditActivityQuestionSetName : String
    var QuestionBySectionList : [QuestionBySection]
    
    override init() {
        AuditActivityQuestionSetId = 0
        AuditActivityQuestionSetName = ""
        QuestionBySectionList = [QuestionBySection]()
    }
}

class AuditActivityQuestionSetQuestionResponseModel : Serializable {
    
    var AuditActivityQuestionSetId : Int
    var Priority : String
    var QuestionStatus : Int
    var ResponseCategory : String
    
    override init() {
        AuditActivityQuestionSetId = 0
        Priority = ""
        QuestionStatus = 0
        ResponseCategory = ""
    }
}

class QuestionResponseSectionModel : Serializable {
    
    var SerialNumber : Int
    var Name : String
    
    override init() {
        SerialNumber = 0
        Name = ""
    }
}

class QuestionResponseModel : Serializable {
    
    var AuditActivityQuestionSetQuestionResponseId : Int
    var SerialNumber : Int
    var SectionSerialNumber : Int
    var Name : String
    var AuditResponse : String
    var Priority : String
    var ResponseCategoryName : String
    var FileId : Int
    var FileName : String
    
    
    override init() {
        AuditActivityQuestionSetQuestionResponseId = 0
        SerialNumber = 0
        SectionSerialNumber = 0
        Name = ""
        AuditResponse = ""
        Priority = ""
        ResponseCategoryName = ""
        FileId = 0
        FileName = ""
    }
}

class QuestionBySection : Serializable {

    var SectionName : String
    var SectionNumber : Int
    var QuestionResponseModelList : [QuestionResponseModel]

    override init() {
        SectionName = ""
        SectionNumber = 0
        QuestionResponseModelList = [QuestionResponseModel]()
    }
}
