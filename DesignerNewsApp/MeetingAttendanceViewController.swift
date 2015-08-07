//
//  MeetingAttendanceViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MeetingAttendanceViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var txt_CloseDate: UITextField!
    @IBOutlet weak var txt_OpenDate: UITextField!
    
    var popCloseDatePicker : PopDatePicker?
    var popOpenDatePicker : PopDatePicker?
    
    
    @IBOutlet weak var lbl_LeadAuditor: UILabel!
    @IBOutlet weak var lbl_SiteName: UILabel!
    
    var auditMeeting = AuditActivityMeetingModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitData()
        
        popCloseDatePicker = PopDatePicker(forTextField: txt_CloseDate)
        txt_CloseDate.delegate = self
        
        popOpenDatePicker = PopDatePicker(forTextField: txt_OpenDate)
        txt_OpenDate.delegate = self

        
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
        
        if (textField === txt_CloseDate) {
            
            PopUpPickerHandle(textField,controlPicker : popCloseDatePicker)
            
            return false
        }
        else
            if (textField === txt_OpenDate) {
                
                PopUpPickerHandle(textField,controlPicker : popOpenDatePicker)
                
                return false
        }
            else {
                return true
        }
    }

    func InitData(){
        view.showLoading()
        
        WebApiService.getAuditActivityMeeting(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
            
            if let temp = objectReturn {
                
                self.auditMeeting = temp
                
                self.lbl_LeadAuditor.text = self.auditMeeting.LeadAuditor
                self.lbl_SiteName.text = self.auditMeeting.SiteName
                self.txt_CloseDate.text = self.auditMeeting.CloseMeetingDateDisplay
                self.txt_OpenDate.text = self.auditMeeting.OpenMeetingDateDisplay

                self.view.hideLoading()

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(tableView == self.tableMaster){
//            return self.auditPlanMaster.count
//        }
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

            
            var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("MeetingCell") as! MeetingDetailsViewCell
            
            
            return cell1

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        self.view.showLoading()
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat =  NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-AU"))
        
        let date1 = formatter.dateFromString(self.txt_CloseDate.text)
        let date2 = formatter.dateFromString(self.txt_OpenDate.text)
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        self.auditMeeting.CloseMeetingDate = dateFormatter.stringFromDate(date1!)

        self.auditMeeting.OpenMeetingDate = dateFormatter.stringFromDate(date2!)

        WebApiService.postAuditActivityMeeting(LocalStore.accessToken()!, AuditActivityMeeting: self.auditMeeting) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){

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
}
