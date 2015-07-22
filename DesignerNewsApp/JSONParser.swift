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

    
    static func parseStoriesArray(data: NSData?) -> [Story] {
        if let data = data {
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? [NSDictionary] {
                return array.map(self.parseStory) ?? []
            }
        }
        return []
    }

    private static func parseStory(story: NSDictionary) -> Story {
        let id = story["id"] as? Int ?? 0
        let title = story["title"] as? String ?? ""
        let url = story["url"] as? String ?? ""
        let commentHTML = story["comment_html"] as? String ?? ""
        let userDisplayName = story["user_display_name"] as? String ?? ""
        let userJob = story["user_job"] as? String ?? ""
        let voteCount = story["vote_count"] as? Int ?? 0
        let commentCount = story["comment_count"] as? Int ?? 0
        let createdAt = story["created_at"] as? String ?? ""
        let badge = story["badge"] as? String ?? ""
        let userPortraitUrl = story["user_portrait_url"] as? String

        let unparsedComments = story["comments"] as? [NSDictionary] ?? []
        let parsedComments = unparsedComments.map(flattenedComments)
        let flattenedParsedComments = parsedComments.reduce([], combine: +)

        return Story(id: id, title: title, url: url, commentHTML: commentHTML, userDisplayName: userDisplayName, userJob: userJob, voteCount: voteCount, commentCount: commentCount, createdAt: createdAt, badge: badge, userPortraitUrl: userPortraitUrl, comments: flattenedParsedComments)
    }

    static func parseComment(comment: NSDictionary) -> Comment {
        let id = comment["id"] as? Int ?? 0
        let bodyHTML = comment["body_html"] as? String ?? ""
        let depth = comment["depth"] as? Int ?? 0
        let userDisplayName = comment["user_display_name"] as? String ?? ""
        let userJob = comment["user_job"] as? String ?? ""
        let voteCount = comment["vote_count"] as? Int ?? 0
        let createdAt = comment["created_at"] as? String ?? ""
        let userPortraitUrl = comment["user_portrait_url"] as? String

        return Comment(id: id, bodyHTML: bodyHTML, depth: depth, userDisplayName: userDisplayName, userJob: userJob, voteCount: voteCount, createdAt: createdAt, userPortraitUrl: userPortraitUrl)
    }

    private static func flattenedComments(comment: NSDictionary) -> [Comment] {
        let comments = comment["comments"] as? [NSDictionary] ?? []
        return comments.reduce([parseComment(comment)]) { acc, x in
            acc + self.flattenedComments(x)
        }
    }

//    // MARK: Helper
//
//    private static func dictionariesFromData(data: NSData?) -> [NSDictionary]? {
//        if let data = data {
//            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary {
//                if let items = dictionary["stories"] as? [NSDictionary] {
//                    return items
//                }
//            }
//        }
//        return nil
//    }
}
