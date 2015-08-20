

import Alamofire

struct WebApiService {


    private static let baseURL = LocalStore.accessDomain()!
    
    private enum ResourcePath: Printable {
        case Login
        case Download
        case ResponseCategoryList
        case AuditRequestList
        case AuditRequestStartAudit
        case AuditRequestStatusList
        case AuditActivitySiteDetail
        
        case AuditActivityAuditDetail
        case AuditActivityAuditDetailEdit
        
        case AuditActivityBookingDetailList
        case AuditActivityBookingDetailAdd
        case AuditActivityBookingDetailDelete
        case AuditActivityBookingDetailEdit
        case AuditActivityBookingDetailSelect
        
        case AuditActivityAudtiPlanList
        case AuditActivityAuditPlanAdd
        case AuditActivityAuditPlanDelete
        case AuditActivityAuditPlanSelect
        case AuditActivityAuditPlanEdit
        
        case AuditActivityMeetingDateSelect
        case AuditActivityMeetingDateEdit
        case AuditActivityMeetingAttendanceRecordList
        case AuditActivityMeetingAttendanceRecordAdd
        case AuditActivityMeetingAttendanceRecordDelete
        case AuditActivityMeetingAttendanceRecordEdit
        case AuditActivityMeetingAttendanceRecordSelect
        
        case AuditActivityQuestionSetList
        case AuditActivityQuestionSetQuestionResponseList
        case AuditActivityQuestionSetQuestionResponseSelect
        case AuditActivityQuestionSetQuestionResponsePieChart
        case AuditActivityQuestionSetQuestionResponseEdit
        
        case AuditActivityConfirmSubmitSelect
        case AuditActivityConfirmSubmitEdit
        case AuditActivityHistoryList
        case AuditOutcomeList
        
        
        var description: String {
            switch self {
                case .Login: return "/Api/Login"
                case .Download: return "/Api/GetFileDocument/?fileId="
                case .AuditRequestList: return "/Api/AuditRequestList"
                case .AuditRequestStartAudit: return "/Api/AuditRequestStartAudit"
                case .ResponseCategoryList: return "/Api/ResponseCategoryList"
                
                case .AuditRequestStatusList: return "/Api/AuditRequestStatusList"
                case .AuditActivitySiteDetail : return "/Api/AuditActivitySiteDetail"
                case .AuditActivityAuditDetail : return "/Api/AuditActivityAuditDetail"
                case .AuditActivityAuditDetailEdit : return "/Api/AuditActivityAuditDetailEdit"
                case .AuditActivityBookingDetailList : return "/Api/AuditActivityBookingDetailList"
                case .AuditActivityBookingDetailAdd : return "/Api/AuditActivityBookingDetailAdd"
                case .AuditActivityBookingDetailDelete : return "/Api/AuditActivityBookingDetailDelete"
                case .AuditActivityBookingDetailEdit : return "/Api/AuditActivityBookingDetailEdit"
                case .AuditActivityBookingDetailSelect : return "/Api/AuditActivityBookingDetailSelect"
                case .AuditActivityAudtiPlanList : return "/Api/AuditActivityAudtiPlanList"
                case .AuditActivityAuditPlanAdd : return "/Api/AuditActivityAuditPlanAdd"
                case .AuditActivityAuditPlanDelete : return "/Api/AuditActivityAuditPlanDelete"
                case .AuditActivityAuditPlanSelect : return "/Api/AuditActivityAuditPlanSelect"
                case .AuditActivityAuditPlanEdit : return "/Api/AuditActivityAuditPlanEdit"
                case .AuditActivityMeetingDateSelect : return "/Api/AuditActivityMeetingDateSelect"
                case .AuditActivityMeetingDateEdit : return "/Api/AuditActivityMeetingDateEdit"
                case .AuditActivityMeetingAttendanceRecordList : return "/Api/AuditActivityMeetingAttendanceRecordList"
                case .AuditActivityMeetingAttendanceRecordAdd : return "/Api/AuditActivityMeetingAttendanceRecordAdd"
                case .AuditActivityMeetingAttendanceRecordDelete : return "/Api/AuditActivityMeetingAttendanceRecordDelete"
                case .AuditActivityMeetingAttendanceRecordEdit : return "/Api/AuditActivityMeetingAttendanceRecordEdit"
                case .AuditActivityMeetingAttendanceRecordSelect : return "/Api/AuditActivityMeetingAttendanceRecordSelect"
                case .AuditActivityQuestionSetList : return "/Api/AuditActivityQuestionSetList"
                case .AuditActivityQuestionSetQuestionResponseList : return "/Api/AuditActivityQuestionSetQuestionResponseList"
                case .AuditActivityQuestionSetQuestionResponsePieChart : return "/Api/AuditActivityQuestionSetQuestionResponsePieChart"
                case .AuditActivityQuestionSetQuestionResponseSelect : return "/Api/AuditActivityQuestionSetQuestionResponseSelect"
                case .AuditActivityQuestionSetQuestionResponseEdit : return "/Api/AuditActivityQuestionSetQuestionResponseEdit"
                
                case .AuditActivityConfirmSubmitSelect : return "/Api/AuditActivityConfirmSubmitSelect"
                case .AuditActivityConfirmSubmitEdit : return "/Api/AuditActivityConfirmSubmitEdit"
                case .AuditActivityHistoryList : return "/Api/AuditActivityHistoryList"
                case .AuditOutcomeList : return "/Api/AuditOutcomeList"
            }
        }
    }

    static func loginWithUsername(Username: String, password: String, response: (object: LoginModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.Login.description

        
        let parameters = [
            "Item": [
                "Username": Username,
                "Password": password
            ]
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json == nil ){
                response(object: nil)
            }
            else
            {
            
                let jsonObject = JSON(json!)

                let IsSuccess = jsonObject["IsSuccess"].bool
            
                if(IsSuccess?.boolValue == true)
                {
                    if let Item = jsonObject["Item"].dictionaryObject {
                        
                        let Return = JSONParser.parseLoginModel(Item as NSDictionary)
                        response (object : Return)
                    }
                }
                else
                {
                    response(object: nil)
                }
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
    
    static func postAuditRequestStartAudit(token: String, AuditRequestUrlId: String, response : (objectReturn : AuditRequestStartAuditModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditRequestStartAudit.description
        
        
        var parameters  = [
            "TokenNumber" : token,
            "AuditRequestUrlId" : AuditRequestUrlId
        ]
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                println(jsonObject)
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                    let Return = JSONParser.parseAuditRequestStartAudit(Item as NSDictionary)
                    response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
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
    
    static func postAuditActivityAuditDetail(token: String, AuditActivityDetail: AuditActivityAuditDetailModel, response : (objectReturn : JsonReturnModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityAuditDetailEdit.description
        
        
        var parameters  = [
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
                 "AuditActivityDayListJson" : AuditActivityDetail.AuditActivityDayListJson]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        //println(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess

                }
                
                if let Errors = jsonObject["Errors"].arrayObject {

                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
        }
        
    }
    
    static func getAuditActivityBookingDetailList(token: String, AuditActivityUrlId: String, response : (objectReturn : [AuditActivityBookingDetaiModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityBookingDetailList.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        var arrayReturn = [AuditActivityBookingDetaiModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Items"].arrayObject {
                            
                            arrayReturn = JSONParser.parseAuditActivityBookingDetaiModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func postAuditActivityBookingDetail(token: String, bookingItem: AuditActivityBookingDetaiModel, Type : Bool, response : (objectReturn : JsonReturnModel?) -> ()) {
        
        var urlString : String = ""
        
        if Type {
             urlString = baseURL + ResourcePath.AuditActivityBookingDetailAdd.description
        }
        else
        {
             urlString = baseURL + ResourcePath.AuditActivityBookingDetailEdit.description

        }
        
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "Id": bookingItem.Id,
                "AuditActivityUrlId": bookingItem.AuditActivityUrlId,
                "Item" : bookingItem.Item,
                "Notes" : bookingItem.Notes,
                "Attachment" : [
                    "FileName" : bookingItem.Attachment.FileName,
                    "ContentType" : bookingItem.Attachment.ContentType,
                    "Size" : bookingItem.Attachment.Size,
                    "FileContent" : bookingItem.Attachment.FileContent
                ]
            ]
        ]
        
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }    

        }
        
    }
    
    static func postAuditActivityBookingDetailDelete(token: String, Id: Int,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditActivityBookingDetailDelete.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id": Id
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }

    }
    
    static func getAuditActivityBookingDetail(token: String, Id: Int, response : (objectReturn : AuditActivityBookingDetaiModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityBookingDetailSelect.description
        
        
        var parameters  : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id" : Id
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                println(jsonObject)
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                    let Return = JSONParser.parseAuditActivityBookingDetail(Item as NSDictionary)
                    response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func getFile(fileId : Int , func_response : (objectReturn : NSURL) -> ()) {
        
        let urlString = baseURL + ResourcePath.Download.description + fileId.description
        
        var tempURL = NSURL()
        
        
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                var localImageURL = directoryURL.URLByAppendingPathComponent("\(fileId).\(response.suggestedFilename!)")
                
                
                tempURL = localImageURL
                
                return localImageURL
            }

            return temporaryURL
        }
        
        // deo hieu ra lam sao ???
        Alamofire.download(.GET, urlString, destination).response(){
            (_, _, data, _) in
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                var error: NSError?
                let urls = NSFileManager.defaultManager().contentsOfDirectoryAtURL(directoryURL, includingPropertiesForKeys: nil, options: nil, error: &error)
                
                if error == nil {
                    func_response(objectReturn : tempURL)
                }
            }
        }
    }
    
    static func getAuditActivityAudtiPlanList(token: String, AuditActivityUrlId: String, response : (objectReturn : [AuditActivityAuditPlanModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityAudtiPlanList.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        var arrayReturn = [AuditActivityAuditPlanModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                  //  println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Items"].arrayObject {
                            
                            arrayReturn = JSONParser.parseAuditActivityPlanModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }

    static func postAuditActivityAuditPlanAdd(token: String, object : AuditActivityAuditPlanModel, type : Bool,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        
        var urlString : String = ""
        
        if type {
            urlString = baseURL + ResourcePath.AuditActivityAuditPlanAdd.description
        }
        else
        {
            urlString = baseURL + ResourcePath.AuditActivityAuditPlanEdit.description
            
        }

        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "AuditActivityId" : object.AuditActivityId,
                "AuditActivityAuditPlanId" : object.AuditActivityAuditPlanId,
                "AuditActivityDayId" : object.AuditActivityDayId,
                "TimeText" : object.TimeText,
                "Activity" : object.Activity,
                "ResoucesRequired" : object.ResoucesRequired
            ]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }
    
    static func postAuditActivityAuditPlanDelete(token: String, Id: Int,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditActivityAuditPlanDelete.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id": Id
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }
    
    static func getAuditActivityAuditPlan(token: String, Id: Int, response : (objectReturn : AuditActivityAuditPlanModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityAuditPlanSelect.description
        
        
        var parameters  : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id" : Id
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                    let Return = JSONParser.parseAuditActivityAuditPlan(Item as NSDictionary)
                    response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func getAuditActivityMeeting(token: String, AuditActivityUrlId: String, response : (objectReturn : AuditActivityMeetingModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityMeetingDateSelect.description
        
        
        var parameters  : [String:AnyObject] = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
              
                
                if let Item = jsonObject["Item"].dictionaryObject {
                    
                    let Return = JSONParser.parseAuditActivityMeetingModel(Item as NSDictionary)
                    response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func postAuditActivityMeeting(token: String, AuditActivityMeeting: AuditActivityMeetingModel, response : (objectReturn : JsonReturnModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityMeetingDateEdit.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "UrlId": AuditActivityMeeting.UrlId,
                "OpenMeetingDate": AuditActivityMeeting.OpenMeetingDate,
                "CloseMeetingDate" : AuditActivityMeeting.CloseMeetingDate
            ]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        //println(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                  print(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
        }
        
    }
    
    static func getAuditActivityMeetingAttendanceRecordList(token: String, AuditActivityUrlId: String, response : (objectReturn : [AuditActivityMeetingAttendanceRecordModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityMeetingAttendanceRecordList.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        var arrayReturn = [AuditActivityMeetingAttendanceRecordModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //  println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Items"].arrayObject {
                            
                            arrayReturn = JSONParser.parseAuditActivityMeetingAttendanceRecordModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }

    static func postAuditActivityMeetingAttendanceRecord(token: String, MeetingRecord: AuditActivityMeetingAttendanceRecordModel, AddMode : Bool, response : (objectReturn : JsonReturnModel?) -> ()){
        
        
        var urlString : String = ""
        
        if AddMode {
            urlString = baseURL + ResourcePath.AuditActivityMeetingAttendanceRecordAdd.description
        }
        else
        {
            urlString = baseURL + ResourcePath.AuditActivityMeetingAttendanceRecordEdit.description
            
        }
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "Id" : MeetingRecord.Id,
                "AuditActivityUrlId": MeetingRecord.AuditActivityUrlId,
                "Name": MeetingRecord.Name,
                "Position" : MeetingRecord.Position,
                "SignOpenMeeting" : MeetingRecord.SignOpenMeeting,
                "SignCloseMeeting" : MeetingRecord.SignCloseMeeting
            ]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        //println(parameters)
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
        }
        
    }
    
    static func postMeetingAttendanceRecordDelete(token: String, Id: Int,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditActivityMeetingAttendanceRecordDelete.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id": Id
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }
    
    static func getAuditActivityMeetingAttendanceRecordModel(token: String, Id: Int, response : (objectReturn : AuditActivityMeetingAttendanceRecordModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityMeetingAttendanceRecordSelect.description
        
        
        var parameters  : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id" : Id
        ]
        
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                

                if let Item = jsonObject["Item"].dictionaryObject {
                    
                    let Return = JSONParser.parseObjectAuditActivityMeetingAttendanceRecord(Item as NSDictionary)
                    response (objectReturn : Return)
                }
                
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func getAuditActivityQuestionSetList(token: String, AuditActivityUrlId: String, response : (objectReturn : [AuditActivityQuestionSetModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityQuestionSetList.description
        
        
        var parameters = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        var arrayReturn = [AuditActivityQuestionSetModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].arrayObject {
                            
                            arrayReturn = JSONParser.parseAuditActivityQuestionSetModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    

    static func getAuditActivityQuestionSetQuestionResponseList(token: String, QuestionRespond: AuditActivityQuestionSetQuestionResponseModel, response : (objectReturn : AuditActivityQuestionSetModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityQuestionSetQuestionResponseList.description
        
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item" : [
                "AuditActivityQuestionSetId" : QuestionRespond.AuditActivityQuestionSetId,
                "Priority" : QuestionRespond.Priority,
                "QuestionStatus" : QuestionRespond.QuestionStatus,
                "ResponseCategory" : QuestionRespond.ResponseCategory
            ]
        ]
        
        var arrayReturn = AuditActivityQuestionSetModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)

                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].dictionaryObject {
                            
                            arrayReturn = JSONParser.parseAuditActivityQuestionSetQuestionResponseList(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    
    static func getAuditActivityQuestionSetQuestionResponsePieChart(token: String, AuditActivityQuestionSetId: Int, response : (objectReturn : QuestionChartList?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityQuestionSetQuestionResponsePieChart.description
        
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "AuditActivityQuestionSetId" : AuditActivityQuestionSetId
        ]
        
        var arrayReturn = QuestionChartList()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].dictionaryObject {
                            
                            arrayReturn = JSONParser.parseQuestionChartList(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func getAuditActivityQuestionSetQuestionResponseSelect(token: String, Id: Int, response : (objectReturn : QuestionResponseModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityQuestionSetQuestionResponseSelect.description
        
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "Id" : Id
        ]
        
        var arrayReturn = QuestionResponseModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].dictionaryObject {
                            
                            arrayReturn = JSONParser.parseObjectQuestionResponseModel2(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func postAuditActivityQuestionSetQuestionResponseEdit(token: String, object: QuestionResponseModel,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditActivityQuestionSetQuestionResponseEdit.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "Id" : object.AuditActivityQuestionSetQuestionResponseId,
                "AuditResponse" : object.AuditResponse,
                "ResponseCategoryId" : object.ResponseCategoryId,
                "Attachments" : [
                    "FileName" : object.Attachment.FileName,
                    "ContentType" : object.Attachment.ContentType,
                    "Size" : object.Attachment.Size,
                    "FileContent" : object.Attachment.FileContent
                ]
            ]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }
    
    static func getAuditActivityConfirmSubmitSelect(token: String, AuditActivityUrlId: String, response : (objectReturn : AuditActivityConfirmSubmitModel?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditActivityConfirmSubmitSelect.description
        
        
        var parameters : [String:AnyObject] = [
            "TokenNumber" : token,
            "AuditActivityUrlId" : AuditActivityUrlId
        ]
        
        var arrayReturn = AuditActivityConfirmSubmitModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].dictionaryObject {
                            
                            arrayReturn = JSONParser.parseObjectAuditActivityConfirmSubmitModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func postAuditActivityConfirmSubmitEdit(token: String, object: AuditActivityConfirmSubmitModel,  response : (objectReturn : JsonReturnModel?) -> ()) {
        
        let urlString = baseURL + ResourcePath.AuditActivityConfirmSubmitEdit.description
        
        
        var parameters   : [String:AnyObject] = [
            "TokenNumber" : token,
            "Item": [
                "UrlId" : object.UrlId,
                "IsAuditDetailsCompleted" : object.IsAuditDetailsCompleted,
                "IsBookingDetailsCompleted" : object.IsBookingDetailsCompleted,
                "IsAuditPlanCompleted" : object.IsAuditPlanCompleted,
                "IsMeetingAttendanceRecordCompleted" : object.IsMeetingAttendanceRecordCompleted,
                "IsQuestionSetCompleted" : object.IsQuestionSetCompleted,
                "Notes" : object.Notes,
                "AuditOutcomeId" : object.AuditOutcomeId
            ]
        ]
        
        var JsonReturn = JsonReturnModel()
        
        Alamofire.request(.POST, urlString, parameters: parameters , encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if let jsonReturn1: AnyObject = json {
                
                let jsonObject = JSON(jsonReturn1)
                
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    JsonReturn.IsSuccess = IsSuccess
                    
                }
                
                if let Errors = jsonObject["Errors"].arrayObject {
                    
                    let ErrorsReturn = JSONParser.parseError(Errors)
                    
                    JsonReturn.Errors = ErrorsReturn
                    
                }
                
                response (objectReturn : JsonReturn)
            }
            else
            {
                response (objectReturn : nil)
            }
            
        }
        
    }

    static func getAuditOutcomeList(token: String, response : (objectReturn : [AuditOutcomeModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.AuditOutcomeList.description
        
        
        var parameters = [
            "TokenNumber" : token
        ]
        
        var arrayReturn = [AuditOutcomeModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)
                
                //println(jsonObject)
                
                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].arrayObject {
                            
                            arrayReturn = JSONParser.parseAuditOutcomeList(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }
    
    static func getResponseCategoryList(token: String, response : (objectReturn : [ResponseCategoryModel]?) -> ()) {
        
        
        let urlString = baseURL + ResourcePath.ResponseCategoryList.description
        
        
        var parameters = [
            "TokenNumber" : token
        ]
        
        var arrayReturn = [ResponseCategoryModel]()
        
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseJSON { (_, _, json, _) in
            
            if(json != nil) {
                
                let jsonObject = JSON(json!)

                if let IsSuccess = jsonObject["IsSuccess"].bool {
                    
                    if IsSuccess {
                        
                        if let Items = jsonObject["Item"].arrayObject {
                            
                            arrayReturn = JSONParser.parseResponseCategoryModel(Items)
                            response (objectReturn : arrayReturn)
                        }
                    }
                }
            }
        }
        
        response (objectReturn : nil)
    }


}
