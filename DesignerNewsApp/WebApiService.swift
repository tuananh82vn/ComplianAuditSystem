

import Alamofire

struct WebApiService {


    //private static let baseURL = "http://complianceauditsystem.softwarestaging.com.au"
    private static let baseURL = "http://wsandypham:8080"

    private enum ResourcePath: Printable {
        case Login
        case AuditRequestList
        case AuditRequestStatusList
        case AuditActivitySiteDetail
        case AuditActivityAuditDetail
        case AuditActivityAuditDetailEdit
        

        var description: String {
            switch self {
                case .Login: return "/Api/Login"
                case .AuditRequestList: return "/Api/AuditRequestList"
                case .AuditRequestStatusList: return "/Api/AuditRequestStatusList"
                case .AuditActivitySiteDetail : return "/Api/AuditActivitySiteDetail"
                case .AuditActivityAuditDetail : return "/Api/AuditActivityAuditDetail"
                case .AuditActivityAuditDetailEdit : return "/Api/AuditActivityAuditDetailEdit"
            }
        }
    }

    static func loginWithEmail(email: String, password: String, response: (token: String?) -> ()) {
        
        let urlString = baseURL + ResourcePath.Login.description
        
        
        println(urlString)
        
        
        let parameters = [
            "Item": [
                "Username": email,
                "Password": password
            ]
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json == nil ){
                response(token: nil)
            }
            
            let jsonObject = JSON(json!)

            let IsSuccess = jsonObject["IsSuccess"].bool
            
            if(IsSuccess?.boolValue == true)
            {
                let TokenNumber = jsonObject["Item"]["TokenNumber"].string
                response(token: TokenNumber)
            }
            else
            {
                response(token: nil)
            }
        }
    }
    
    static func getAuditRequestList(token: String, filter : AuditRequestFilter, response : (objectReturn : [AuditRequestModel]) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditRequestList.description
        
        var FromDate : String
        var ToDate : String
        
        if let object1 = filter.FromDate
        {
            FromDate =  object1.description
        }
        else
        {
            FromDate = ""
        }
        
        if let object1 = filter.ToDate
        {
            ToDate =  object1.description
        }
        else
        {
            ToDate = ""
        }
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "Page": filter.Page,
                "PageSize": filter.PageSize,
                "Sort" : filter.Sort,
                "SiteName" : filter.SiteName,
                "Status" : filter.Status,
                "FromDate" :  FromDate,
                "ToDate" : ToDate
            ]
        ]
        


        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            var AuditRequestList = [AuditRequestModel]()
            
            let jsonObject = JSON(json!)
            
            
            if let Items = jsonObject["Items"].array {
                
                for var index = 0; index < Items.count; ++index {
                    if let Item = Items[index].dictionaryObject {
                        
                        let AuditRequest = JSONParser.parseAuditRequest(Item as NSDictionary)

                        AuditRequestList.insert(AuditRequest, atIndex: index)
                    }
                }
            }
            
            response (objectReturn : AuditRequestList)
        }
    }
    
    static func getAuditRequestStatusList(token: String, response : (objectReturn : [AuditRequestStatusModel]) -> ()) {


        let urlString = baseURL + ResourcePath.AuditRequestStatusList.description
        
        
        var parameters = [
            "TokenNumber" : token
        ]
        

        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in

        var arrayReturn = [AuditRequestStatusModel]()
            
        if(json != nil){
            
            
            
            let jsonObject = JSON(json!)
            
            
            if let Items = jsonObject["Item"].array {
                
                for var index = 0; index < Items.count; ++index {
                    
                    if let Item = Items[index].dictionaryObject {
                        
                        let AuditRequestStatus = JSONParser.parseAuditRequestStatus(Item as NSDictionary)
                        
                        arrayReturn.insert(AuditRequestStatus, atIndex: index)
                    }
                }
            }
                
         }
            
          response (objectReturn : arrayReturn)
       }
    }
    
    static func getAuditActivitySiteDetail(token: String, AuditActivityUrlId: String, response : (objectReturn : AuditActivitySiteDetailModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivitySiteDetail.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {

                    let jsonObject = JSON(json!)
                
                    if let Item = jsonObject["Item"].dictionaryObject {
                
                        let Return = JSONParser.parseAuditActivitySite(Item as NSDictionary)
                        response (objectReturn : Return)
                    }

                }
            }
            
            response (objectReturn : nil)
        }
    
    static func getAuditActivityAuditDetail(token: String, AuditActivityUrlId: String, response : (objectReturn : AuditActivityAuditDetailModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityAuditDetail.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                      let Return = JSONParser.parseAuditActivityAuditDetail(Item as NSDictionary)
                      response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func postAuditActivityAuditDetail(token: String, AuditActivityDetail: AuditActivityAuditDetailModel, response : (objectReturn : Bool?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityAuditDetailEdit.description
        
        
        var parameters : [String : AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "AuditActivityId": AuditActivityDetail.AuditActivityId,
                "UrlId": AuditActivityDetail.UrlId,
                "AuditStartDate" : AuditActivityDetail.AuditStartDateDisplay,
                "AuditEndDate" : AuditActivityDetail.AuditEndDateDisplay,
                "AuditTypeId" : AuditActivityDetail.AuditTypeId,
                "ScopeOfAudit" :  AuditActivityDetail.ScopeOfAudit,
                "LeadAuditor" : AuditActivityDetail.LeadAuditor,
                 "Phone" : AuditActivityDetail.Phone,
                 "EmailAddress" : AuditActivityDetail.EmailAddress,
                 "AuditActivityDayListJson" : AuditActivityDetail.AuditActivityDayListJson,
            ]

        ]
        
        println(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                println(jsonObject)
                
            }
        }
        
        response (objectReturn : true)
    }
    

}
