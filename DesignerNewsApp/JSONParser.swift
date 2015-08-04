//
//  JSONParser.swift
//  DesignerNewsApp
//
//  Created by André Schneider on 20.01.15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import Foundation

struct JSONParser {


    static func parseAuditRequestStatus(story: NSDictionary) -> AuditRequestStatusModel {
        
        
        let auditrequestObject =  AuditRequestStatusModel()
        
        auditrequestObject.Id = story["Id"] as? Int ?? 0
        
        auditrequestObject.Color = story["Colour"] as? String ?? ""
        
        auditrequestObject.Description = story["Description"] as? String ?? ""
        
        auditrequestObject.DisplayOrder = story["DisplayOrder"] as? Int ?? 0
        
        auditrequestObject.MainStatus = story["MainStatus"] as? Int ?? 0
        
        auditrequestObject.Description = story["Description"] as? String ?? ""
        
        auditrequestObject.Name = story["Name"] as? String ?? ""
        
        return auditrequestObject
    }
    
    


    static func parseAuditRequest(story: NSDictionary) -> AuditRequestModel {
        
        
        let auditrequestObject =  AuditRequestModel()
        
        auditrequestObject.TotalRows = story["TotalRows"] as? Int ?? 0
        
        auditrequestObject.AuditorName = story["AuditorName"] as? String ?? ""
        
        auditrequestObject.AcceptedFromDateDisplay = story["AcceptedFromDateDisplay"] as? String ?? ""
        
        auditrequestObject.AuditorId = story["AuditorId"] as? Int ?? 0
        
        auditrequestObject.QuestionSetName = story["QuestionSetName"] as? String ?? ""
        
        auditrequestObject.CanEditAuditActivity = story["CanEditAuditActivity"] as? Bool ?? false
        
        auditrequestObject.StateName = story["StateName"] as? String ?? ""
        
        auditrequestObject.Suburb = story["Suburb"] as? String ?? ""
        
        auditrequestObject.RequestFromDateDisplay = story["RequestFromDateDisplay"] as? String ?? ""
        
        auditrequestObject.RequestToDateDisplay = story["RequestToDateDisplay"] as? String ?? ""
        
        auditrequestObject.SiteName = story["SiteName"] as? String ?? ""
        
        auditrequestObject.Address = story["Address"] as? String ?? ""
        
        auditrequestObject.AuditActivityId = story["AuditActivityId"] as? Int ?? 0
        
        auditrequestObject.SiteId = story["SiteId"] as? Int ?? 0
        
        auditrequestObject.UrlId = story["UrlId"] as? String ?? ""
        
        auditrequestObject.AcceptedToDateDisplay = story["AcceptedToDateDisplay"] as? String ?? ""
        
        auditrequestObject.AuditCompanyId = story["AuditCompanyId"] as? Int ?? 0
        
        auditrequestObject.QuestionSetUrlId = story["QuestionSetUrlId"] as? String ?? "0"
        
        auditrequestObject.Id = story["Id"] as? Int ?? 0
        
        auditrequestObject.PostCode = story["PostCode"] as? String ?? ""
        
        auditrequestObject.AuditActivityUrlId = story["AuditActivityUrlId"] as? String ?? ""
        
        auditrequestObject.AuditActivityStatusId = story["AuditActivityStatusId"] as? Int ?? 0
        
        auditrequestObject.AuditRequestStatusId = story["AuditRequestStatusId"] as? Int ?? 0
        
        auditrequestObject.CanStartAudit = story["CanStartAudit"] as? Bool ?? false
        
        auditrequestObject.AuditCompanyName = story["AuditCompanyName"] as? String ?? ""
        
        return auditrequestObject
    }
    
    static func parseAuditActivitySite(story: NSDictionary) -> AuditActivitySiteDetailModel {
        
        
        let Object =  AuditActivitySiteDetailModel()
        
        Object.AuditRequestSiteId =             story["AuditRequestSiteId"] as? Int ?? 0
        
        Object.SiteSuburb =                    story["SiteSuburb"] as? String ?? ""
        
        Object.SiteContactEmail =      story["SiteContactEmail"] as? String ?? ""
        
        Object.SitePostCode =     story["SitePostCode"] as? String ?? ""
        
        Object.AuditActivityUrlId =      story["AuditActivityUrlId"] as? String ?? ""
        
        Object.SiteContactPhone =   story["SiteContactPhone"] as? String ?? ""
        
        Object.SiteUrlId =   story["SiteUrlId"] as? String ?? ""
        
        Object.SiteAlternateContactPerson =                    story["SiteAlternateContactPerson"] as? String ?? ""
        
        Object.SiteIndustryTypeName =      story["SiteIndustryTypeName"] as? String ?? ""
        
        Object.SiteState =     story["SiteState"] as? String ?? ""
        
        Object.SiteAlternateContactEmail =      story["SiteAlternateContactEmail"] as? String ?? ""
        
        Object.SiteContactPerson =   story["SiteContactPerson"] as? String ?? ""
        
        Object.SiteAlternateContactPosition =   story["SiteAlternateContactPosition"] as? String ?? ""
        
        Object.SiteCompanyName =   story["SiteCompanyName"] as? String ?? ""
    
        Object.SiteName =   story["SiteName"] as? String ?? ""
        
        Object.SiteAddress =   story["SiteAddress"] as? String ?? ""
        
        Object.SiteAlternateContactPhone =   story["SiteAlternateContactPhone"] as? String ?? ""
        
        return Object
    }
    
    static func parseAuditActivityAuditDetail(story: NSDictionary) -> AuditActivityAuditDetailModel {
        
        
        let Object =  AuditActivityAuditDetailModel()
        
        Object.AuditType =             story["AuditType"] as? String ?? ""
        
        Object.EmailAddress =                    story["EmailAddress"] as? String ?? ""
        
        Object.AuditActivityId =      story["AuditActivityId"] as? Int ?? 0
        
        Object.CanEdit =     story["CanEdit"] as? Bool ?? false
        
        Object.UrlId =      story["UrlId"] as? String ?? ""
        
        Object.AuditTypeId =   story["AuditTypeId"] as? Int ?? 0
        
        Object.Phone =   story["Phone"] as? String ?? ""
        
        Object.AuditEndDateDisplay =                    story["AuditEndDateDisplay"] as? String ?? ""
        
        Object.AuditActivityStatusColor =      story["AuditActivityStatusColor"] as? String ?? ""
        
        Object.ScopeOfAudit =     story["ScopeOfAudit"] as? String ?? ""
        
        Object.AuditActivityStatusName =      story["AuditActivityStatusName"] as? String ?? ""
        
        Object.CanApprove =   story["CanApprove"] as? Bool ?? false
        
        Object.AuditRequestId =   story["AuditRequestId"] as? Int ?? 0
        
        Object.AuditStartDate =   story["AuditStartDate"] as? NSDate ?? nil
        
        Object.AuditActivityStatusId =   story["AuditActivityStatusId"] as? Int ?? 0
        
        Object.LeadAuditor =   story["LeadAuditor"] as? String ?? ""
        
        Object.AuditStartDateDisplay =   story["AuditStartDateDisplay"] as? String ?? ""
        
        Object.AuditEndDate =   story["AuditEndDate"] as? NSDate ?? nil
        
        Object.ReportId =   story["ReportId"] as? Int ?? 0
        
        var TimeOnSite = [AuditActivityDayModel?]()
        var TimeOnFactory = [AuditActivityDayModel?]()
        
        if let Items = (story["ListAuditActivityDay"] as? NSArray) as Array? {
            
            
            for var index = 0; index < Items.count; ++index {
                if let Item = Items[index] as? NSDictionary {
                    
                    let temp = JSONParser.parseAuditActivityDay(Item as NSDictionary)
                    
                    
                    if(temp.DayType == 1){
                        if(TimeOnFactory.isEmpty){
                            TimeOnFactory.insert(temp, atIndex: 0)
                        }
                        else{
                            TimeOnFactory.insert(temp, atIndex: TimeOnFactory.count)
                        }
                    }
                    
                    if(temp.DayType == 2){
                        if(TimeOnSite.isEmpty){
                            TimeOnSite.insert(temp, atIndex: 0)
                        }
                        else{
                            TimeOnSite.insert(temp, atIndex: TimeOnSite.count)
                        }
                    }
                }
            }
        }
        
        Object.TimeOnFactoryFloor = TimeOnFactory
        Object.TimeOnSite = TimeOnSite
        
        
        
        return Object
    }
    
    
    static func parseAuditActivityDay(story: NSDictionary) -> AuditActivityDayModel {
        
        
        let Object =  AuditActivityDayModel()
        
        Object.DayDateDisplay =             story["DayDateDisplay"] as? String ?? ""
        
        Object.DayNumber =                    story["DayNumber"] as? Int ?? 0
        
        Object.DayType =      story["DayType"] as? Int ?? 0

        
        return Object
    }

    static func parseError(story: NSArray) -> [Error] {
        
        var ErrorArray = [Error]()
        
        if let Items = story as Array? {
        
            for var index = 0; index < Items.count; ++index {
    
                if let Item = Items[index] as? NSDictionary {
                
                    let temp = JSONParser.parseObjectError(Item as NSDictionary)
            
                    ErrorArray.append(temp)
                }
            }
        }
        
        return ErrorArray
    }
            
    static func parseObjectError(story: NSDictionary) -> Error {
        
        let Object =  Error()
        
        Object.ErrorMessage = story["ErrorMessage"] as? String ?? ""
        
        return Object
    }
    
    static func parseAuditActivityBookingDetaiModel(story: NSArray) -> [AuditActivityBookingDetaiModel] {
        
        var BookingArray = [AuditActivityBookingDetaiModel]()
        
        if let Items = story as Array? {
            
            for var index = 0; index < Items.count; ++index {
                
                if let Item = Items[index] as? NSDictionary {
                    
                    let temp = JSONParser.parseObjectBooking(Item as NSDictionary)
                    
                    BookingArray.append(temp)
                }
            }
        }
        
        return BookingArray
    }
    
    static func parseObjectBooking(story: NSDictionary) -> AuditActivityBookingDetaiModel {
        
        let Object =  AuditActivityBookingDetaiModel()
        
        Object.Id = story["Id"] as? Int ?? 0
        
        Object.AuditActivityId = story["AuditActivityId"] as? Int ?? 0
        
        Object.Notes = story["Notes"] as? String ?? ""
        
        Object.FileId = story["FileId"] as? Int ?? 0
        
        Object.FileName = story["FileName"] as? String ?? ""
        
        Object.Item = story["Item"] as? String ?? ""
        
        Object.SerialNumber = story["SerialNumber"] as? Int ?? 0
        
        return Object
    }
    
    static func parseAuditActivityBookingDetail(story: NSDictionary) -> AuditActivityBookingDetaiModel {
        
        
        let Object =  AuditActivityBookingDetaiModel()
        
        Object.Id =                                 story["Id"] as? Int ?? 0
        
        Object.AuditActivityId =                    story["AuditActivityId"] as? Int ?? 0
        
        Object.Item =                               story["Item"] as? String ?? ""
        
        Object.Notes =                              story["Notes"] as? String ?? ""
        
        Object.DisplayFileName =                    story["DisplayFileName"] as? String ?? ""
        
        Object.FileId =                             story["FileId"] as? Int ?? 0
        
        Object.AuditActivityBookingAttachments =    story["AuditActivityBookingAttachments"] as? String ?? ""
        
        Object.UpdatedBy =    story["UpdatedBy"] as? String ?? ""
        
        Object.UpdatedDate =    story["UpdatedDate"] as? String ?? ""
        
        Object.FileName =    story["FileName"] as? String ?? ""
        
        Object.Size =    story["Size"] as? Float ?? 0
        
        Object.MIMEType =    story["MIMEType"] as? String ?? ""
        
        Object.FolderPath =    story["FolderPath"] as? String ?? ""

        //Object.Attachment =    story["FolderPath"] as? String ?? ""
        
        return Object
    }


}
