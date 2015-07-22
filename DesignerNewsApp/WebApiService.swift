

import Alamofire

struct WebApiService {


    private static let baseURL = "http://complianceauditsystem.softwarestaging.com.au"
    //private static let baseURL = "http://wsandypham:8080"

    private enum ResourcePath: Printable {
        case Login
        case AuditRequestList
        case AuditRequestStatusList
        

        var description: String {
            switch self {
            case .Login: return "/api/login"
            case .AuditRequestList: return "/api/auditrequestlist"
                
            case .AuditRequestStatusList: return "/api/AuditRequestStatusList"
            }
        }
    }

    static func loginWithEmail(email: String, password: String, response: (token: String?) -> ()) {
        
        let urlString = baseURL + ResourcePath.Login.description
        
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
        
        //println(parameters)

        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            var AuditRequestList = [AuditRequestModel]()
            
            let jsonObject = JSON(json!)
            
            println(jsonObject)
            
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

        
        println(ResourcePath.AuditRequestStatusList.description)
        
        let urlString = baseURL + ResourcePath.AuditRequestStatusList.description
        
        var parameters = [
            "TokenNumber" : token
        ]
        
        
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in

        var arrayReturn = [AuditRequestStatusModel]()
            
        if(json != nil){
            
            
            
            let jsonObject = JSON(json!)
            
            println(jsonObject)
            
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

}
