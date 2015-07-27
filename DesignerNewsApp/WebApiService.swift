

import Alamofire

struct WebApiService {


    private static let baseURL = "http://complianceauditsystem.softwarestaging.com.au"
    //private static let baseURL = "http://wsandypham:8080"

    private enum ResourcePath: Printable {
        case Login
        case AuditRequestList
        case AuditRequestStatusList
        case AuditActivitySiteDetail
        case AuditActivityAuditDetail
        

        var description: String {
            switch self {
                case .Login: return "/Api/Login"
                case .AuditRequestList: return "/Api/AuditRequestList"
                case .AuditRequestStatusList: return "/Api/AuditRequestStatusList"
                case .AuditActivitySiteDetail : return "/Api/AuditActivitySiteDetail"
                case .AuditActivityAuditDetail : return "/Api/AuditActivityAuditDetail"
                
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
        
        
        println(urlString)
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "Page": filter.Page,
                "PageSize": filter.PageSize,
                "Sort" : filter.Sort,
                "SiteName" : filter.SiteName,
                "Status" : filter.Status,
                "FromDate" : filter.FromDate.description,
                "ToDate" : filter.ToDate.description
            ]
        ]
        


        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            var AuditRequestList = [AuditRequestModel]()
            
            let jsonObject = JSON(json!)
            
            //println(jsonObject)
            
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
        
        println(urlString)
        
        var parameters = [
            "TokenNumber" : token
        ]
        

        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in

        var arrayReturn = [AuditRequestStatusModel]()
            
        if(json != nil){
            
            
            
            let jsonObject = JSON(json!)
            
            //println(jsonObject)
            
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
        
        println(urlString)
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {

                    let jsonObject = JSON(json!)
                
                    //println(jsonObject)
                
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
        
        //println(urlString)
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                      let Return = JSONParser.parseAuditActivityAuditDetail(Item as NSDictionary)
                      response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }

}
