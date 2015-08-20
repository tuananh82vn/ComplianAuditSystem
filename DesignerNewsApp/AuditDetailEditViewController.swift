//
//  AuditDetailEditViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 28/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditDetailEditViewController: UIViewController , UITextFieldDelegate , SSRadioButtonControllerDelegate {

    var auditActivityDetail = AuditActivityAuditDetailModel()
    var AuditActivityDayListJson =  Array<AuditActivityDayModel>()
    
    @IBOutlet weak var DateFrom: UITextField!
    @IBOutlet weak var DateTo: UITextField!
    
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var ScopeOfAudit: UITextField!
    @IBOutlet weak var LeadAuditor: UITextField!


    @IBOutlet weak var FactoryDay1: UITextField!
    @IBOutlet weak var FactoryDay2: UITextField!
    @IBOutlet weak var FactoryDay3: UITextField!
    @IBOutlet weak var FactoryDay4: UITextField!
    @IBOutlet weak var FactoryDay5: UITextField!
    
    @IBOutlet weak var SiteDay1: UITextField!
    @IBOutlet weak var SiteDay2: UITextField!
    @IBOutlet weak var SiteDay3: UITextField!
    @IBOutlet weak var SiteDay4: UITextField!
    @IBOutlet weak var SiteDay5: UITextField!
    
    @IBOutlet weak var ButtonGap: SSRadioButton!
    @IBOutlet weak var ButtonCer: SSRadioButton!
    @IBOutlet weak var ButtonRoutine: SSRadioButton!
    
    var radioButtonController: SSRadioButtonsController?
    
//    var popDateFromPicker : PopDatePicker?
//    var popDateToPicker : PopDatePicker?
    
    var popFactoryDay1Picker : PopDatePicker?
    var popFactoryDay2Picker : PopDatePicker?
    var popFactoryDay3Picker : PopDatePicker?
    var popFactoryDay4Picker : PopDatePicker?
    var popFactoryDay5Picker : PopDatePicker?
    
    var popSiteDay1Picker : PopDatePicker?
    var popSiteDay2Picker : PopDatePicker?
    var popSiteDay3Picker : PopDatePicker?
    var popSiteDay4Picker : PopDatePicker?
    var popSiteDay5Picker : PopDatePicker?
    
    var originalCenter: CGPoint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        originalCenter = view.center
        
        view.showLoading()

        InitUI()
        
        InitData()
        
        view.hideLoading()

        // Do any additional setup after loading the view.
    }
    
    func InitUI(){
    
        radioButtonController = SSRadioButtonsController(buttons: ButtonGap, ButtonCer, ButtonRoutine)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
//        popDateFromPicker = PopDatePicker(forTextField: DateFrom)
//        DateFrom.delegate = self
//        
//        popDateToPicker = PopDatePicker(forTextField: DateTo)
//        DateTo.delegate = self
        
        popFactoryDay1Picker = PopDatePicker(forTextField: FactoryDay1)
        FactoryDay1.delegate = self
        
        popFactoryDay2Picker = PopDatePicker(forTextField: FactoryDay2)
        FactoryDay2.delegate = self
        
        popFactoryDay3Picker = PopDatePicker(forTextField: FactoryDay3)
        FactoryDay3.delegate = self
        
        popFactoryDay4Picker = PopDatePicker(forTextField: FactoryDay4)
        FactoryDay4.delegate = self
        
        popFactoryDay5Picker = PopDatePicker(forTextField: FactoryDay5)
        FactoryDay5.delegate = self
        
        popSiteDay1Picker = PopDatePicker(forTextField: SiteDay1)
        SiteDay1.delegate = self
        
        popSiteDay2Picker = PopDatePicker(forTextField: SiteDay2)
        SiteDay2.delegate = self
        
        popSiteDay3Picker = PopDatePicker(forTextField: SiteDay3)
        SiteDay3.delegate = self
        
        popSiteDay4Picker = PopDatePicker(forTextField: SiteDay4)
        SiteDay4.delegate = self
        
        popSiteDay5Picker = PopDatePicker(forTextField: SiteDay5)
        SiteDay5.delegate = self

        
    }
    
    func InitData(){
        
        self.ScopeOfAudit.text = auditActivityDetail.ScopeOfAudit
        self.LeadAuditor.text = auditActivityDetail.LeadAuditor
        self.Phone.text = auditActivityDetail.Phone
        self.Email.text = auditActivityDetail.EmailAddress
        
        self.DateFrom.text = auditActivityDetail.AuditStartDateDisplay
        self.DateTo.text = auditActivityDetail.AuditEndDateDisplay
        
        if (auditActivityDetail.TimeOnFactoryFloor.count >= 1) {
            if let Factory1 = auditActivityDetail.TimeOnFactoryFloor[0] {
                FactoryDay1.text = Factory1.DayDateDisplay
            }
        }
        if (auditActivityDetail.TimeOnFactoryFloor.count >= 2) {

            if let Factory2 = auditActivityDetail.TimeOnFactoryFloor[1] {
                FactoryDay2.text = Factory2.DayDateDisplay
            }
        }
        if (auditActivityDetail.TimeOnFactoryFloor.count >= 3) {

            if let Factory3 = auditActivityDetail.TimeOnFactoryFloor[2] {
                FactoryDay3.text = Factory3.DayDateDisplay
            }
        }
        if (auditActivityDetail.TimeOnFactoryFloor.count >= 4) {

            if let Factory4 = auditActivityDetail.TimeOnFactoryFloor[3] {
                FactoryDay4.text = Factory4.DayDateDisplay
            }
        }
        if (auditActivityDetail.TimeOnFactoryFloor.count >= 5) {

            if let Factory5 = auditActivityDetail.TimeOnFactoryFloor[4] {
                FactoryDay5.text = Factory5.DayDateDisplay
            }
        }
        
    
        
        if (auditActivityDetail.TimeOnSite.count >= 1 ) {
            if let Site1 = auditActivityDetail.TimeOnSite[0] {
                SiteDay1.text = Site1.DayDateDisplay
            }
        }
        
        if (auditActivityDetail.TimeOnSite.count >= 2 ) {

            if let Site2 = auditActivityDetail.TimeOnSite[1] {
                SiteDay2.text = Site2.DayDateDisplay
            }
        }
        
        if (auditActivityDetail.TimeOnSite.count >= 3 ) {
            
            if let Site3 = auditActivityDetail.TimeOnSite[2] {
                SiteDay3.text = Site3.DayDateDisplay
            }
        }
        
        if (auditActivityDetail.TimeOnSite.count >= 4 ) {
            
            if let Site4 = auditActivityDetail.TimeOnSite[3] {
                SiteDay4.text = Site4.DayDateDisplay
            }
        }
        
        if (auditActivityDetail.TimeOnSite.count >= 5 ) {
            
            if let Site5 = auditActivityDetail.TimeOnSite[4] {
                SiteDay5.text = Site5.DayDateDisplay
            }
            
        }
        
        if (auditActivityDetail.AuditTypeId == 1) {
            self.ButtonGap.selected = true
        }
        else
            if (auditActivityDetail.AuditTypeId == 2) {
                self.ButtonCer.selected = true
        }
            else
                if (auditActivityDetail.AuditTypeId == 3) {
                    self.ButtonRoutine.selected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func PopUpPickerHandle(textField: UITextField, controlPicker : PopDatePicker?){
        
        textField.resignFirstResponder()
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat =  NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-AU"))
        
        var initDate : NSDate?
        
        if(textField.text.length > 0){
        
            initDate = formatter.dateFromString(textField.text)
        }
        else
        {
            initDate = NSDate()
        }
        
        
        let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
            
        }
        
        controlPicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)

    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
//        if (textField === DateFrom) {
//            
//            PopUpPickerHandle(textField,controlPicker : popDateFromPicker)
//            
//            return false
//        }
//        else
//            if (textField === DateTo) {
//                
//                PopUpPickerHandle(textField,controlPicker : popDateToPicker)
//                
//                return false
//            }
//                
//            else
                if (textField === FactoryDay1) {
                    
                    PopUpPickerHandle(textField,controlPicker : popFactoryDay1Picker)
                    
                    return false
                }
                    
                else
                    if (textField === FactoryDay2) {
                        
                        PopUpPickerHandle(textField,controlPicker : popFactoryDay2Picker)
                        
                        return false
                    }
                        
                    else
                        if (textField === FactoryDay3) {
                            
                            PopUpPickerHandle(textField,controlPicker : popFactoryDay3Picker)
                            
                            return false
                        }
                            
                        else
                            if (textField === FactoryDay4) {
                                
                                PopUpPickerHandle(textField,controlPicker : popFactoryDay4Picker)
                                
                                return false
                            }
                                
                            else
                                if (textField === FactoryDay5) {
                                    
                                    PopUpPickerHandle(textField,controlPicker : popFactoryDay5Picker)
                                    
                                    return false
                                }
                                else
                                    if (textField === SiteDay1) {
                                        
                                        PopUpPickerHandle(textField,controlPicker : popSiteDay1Picker)
                                        
                                        return false
                                    }
                                        
                                    else
                                        if (textField === SiteDay2) {
                                            
                                            PopUpPickerHandle(textField,controlPicker : popSiteDay2Picker)
                                            
                                            return false
                                        }
                                            
                                        else
                                            if (textField === SiteDay3) {
                                                
                                                PopUpPickerHandle(textField,controlPicker : popSiteDay3Picker)
                                                
                                                return false
                                            }
                                                
                                            else
                                                if (textField === SiteDay4) {
                                                    
                                                    PopUpPickerHandle(textField,controlPicker : popSiteDay4Picker)
                                                    
                                                    return false
                                                }
                                                    
                                                else
                                                    if (textField === SiteDay5) {
                                                        
                                                        PopUpPickerHandle(textField,controlPicker : popSiteDay5Picker)
                                                        
                                                        return false
                                                    }

        else {
            return true
        }
    }
    
    func didSelectButton(aButton: UIButton?) {
        //println(aButton)
    }

    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        view.showLoading()
        
        self.AuditActivityDayListJson.removeAll(keepCapacity: false)
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat =  NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-AU"))

        self.auditActivityDetail.AuditStartDate = formatter.dateFromString(DateFrom.text)
        
        self.auditActivityDetail.AuditEndDate = formatter.dateFromString(DateTo.text)
        
        if (self.ButtonGap.selected)
        {
            self.auditActivityDetail.AuditTypeId = 1
        }
        if (self.ButtonCer.selected)
        {
            self.auditActivityDetail.AuditTypeId = 2
        }
        if (self.ButtonRoutine.selected)
        {
            self.auditActivityDetail.AuditTypeId = 3
        }
        
        self.auditActivityDetail.ScopeOfAudit = ScopeOfAudit.text
        self.auditActivityDetail.LeadAuditor = LeadAuditor.text
        self.auditActivityDetail.Phone = Phone.text
        self.auditActivityDetail.EmailAddress = Email.text
        
       // self.auditActivityDetail.AuditActivityDayListJson += "["
        
        AddAuditDay(FactoryDay1,DayType: 1,DayNumber: 1)
        AddAuditDay(FactoryDay2,DayType: 1,DayNumber: 2)
        AddAuditDay(FactoryDay3,DayType: 1,DayNumber: 3)
        AddAuditDay(FactoryDay4,DayType: 1,DayNumber: 4)
        AddAuditDay(FactoryDay5,DayType: 1,DayNumber: 5)
        
        AddAuditDay(SiteDay1,DayType: 2,DayNumber: 1)
        AddAuditDay(SiteDay2,DayType: 2,DayNumber: 2)
        AddAuditDay(SiteDay3,DayType: 2,DayNumber: 3)
        AddAuditDay(SiteDay4,DayType: 2,DayNumber: 4)
        AddAuditDay(SiteDay5,DayType: 2,DayNumber: 5)
        

        let jsonCompatibleArray = AuditActivityDayListJson.map { model in
            return [
                "DayNumber":model.DayNumber,
                "DayType":model.DayType,
                "DayDateDisplay":model.DayDateDisplay,
                "DayDate":model.DayDate
            ]
        }
        
        let data = NSJSONSerialization.dataWithJSONObject(jsonCompatibleArray, options: nil, error: nil)
        
        if let jsonString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        {
            self.auditActivityDetail.AuditActivityDayListJson = jsonString as String
        }
        
        
        WebApiService.postAuditActivityAuditDetail(LocalStore.accessToken()!, AuditActivityDetail: self.auditActivityDetail) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("refeshAuditDetail", object: nil)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    var errorMessage : String = ""
                    
                    for var index = 0; index < temp.Errors.count; ++index {
                        
                            errorMessage += temp.Errors[index].ErrorMessage
                        }
                    
                    
                    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    alertController.view.tintColor = UIColor.blackColor()
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func ButtonCancelClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func AddAuditDay(textField : UITextField, DayType : Int , DayNumber : Int){
        if( textField.text.length > 0){
            
            var AuditDay = AuditActivityDayModel()
            
            AuditDay.DayNumber = DayNumber
            
            AuditDay.DayType = DayType
            
            let formatter = NSDateFormatter()
            
            formatter.dateFormat =  NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-AU"))
            
            let date1 = formatter.dateFromString(textField.text)
            
            var dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            AuditDay.DayDate = dateFormatter.stringFromDate(date1!)
            
            self.AuditActivityDayListJson.append(AuditDay)
            
        }
    }

}
