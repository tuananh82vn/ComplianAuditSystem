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
    
    var auditMeetingRecord = [AuditActivityMeetingAttendanceRecordModel]()
    
    var selectedId : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Check Internet
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    self.InitData()
                }
                else
                {
                    var customIcon = UIImage(named: "no-internet")
                    var alertview = JSSAlertView().show2(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                    alertview.setTextTheme(.Light)
                }
        })
        
        popCloseDatePicker = PopDatePicker(forTextField: txt_CloseDate)
        txt_CloseDate.delegate = self
        
        popOpenDatePicker = PopDatePicker(forTextField: txt_OpenDate)
        txt_OpenDate.delegate = self

         NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refeshMeeting", object: nil)
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
    
    
    func refesh(notification: NSNotification){
        InitData()
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
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let filter = AuditRequestFilter()
                    
                    WebApiService.getAuditActivityMeetingAttendanceRecordList(LocalStore.accessToken()!, AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()!) { objectReturn in
                        
                        self.view.hideLoading()
                        
                        if let temp = objectReturn {
                            self.auditMeetingRecord =  temp
                        }
                        
                        self.tableView1.reloadData()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return auditMeetingRecord.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("MeetingCell") as! MeetingDetailsViewCell
        
            cell1.lbl_number.text = (indexPath.row+1).description
        
            cell1.lbl_Name.text = self.auditMeetingRecord[indexPath.row].Name
        
            cell1.lbl_Position.text = self.auditMeetingRecord[indexPath.row].Position
        
            cell1.lbl_Open.text = self.auditMeetingRecord[indexPath.row].SignOpenMeeting
        
            cell1.lbl_Close.text = self.auditMeetingRecord[indexPath.row].SignCloseMeeting
        
            cell1.bt_Delete.tag = self.auditMeetingRecord[indexPath.row].Id
        
            cell1.bt_Delete.addTarget(self, action: "ButtonDeleteClicked:", forControlEvents: .TouchUpInside)
        
            cell1.bt_Edit.tag = self.auditMeetingRecord[indexPath.row].Id
        
            cell1.bt_Edit.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
        
            return cell1

    }
    
    func ButtonEditClicked(sender : UIButton)
    {
        self.selectedId = sender.tag
        
        self.performSegueWithIdentifier("GoToMeetingRecordEdit", sender: sender)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    @IBAction func ButtonAddClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToMeetingRecordAdd", sender: sender)
    }
    
    func doSave(){
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
    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        //Check Internet
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    self.doSave()
                }
                else
                {
                    var customIcon = UIImage(named: "no-internet")
                    var alertview = JSSAlertView().show2(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                    alertview.setTextTheme(.Light)
                }
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToMeetingRecordAdd" {
            let controller = segue.destinationViewController as! MeetingAttendanceAddViewController
            controller.AddMode = true
        }
        else
            if segue.identifier == "GoToMeetingRecordEdit" {
                let controller = segue.destinationViewController as! MeetingAttendanceAddViewController
                controller.AddMode = false
                controller.selectedId = self.selectedId
        }
    }
    
    func ButtonDeleteClicked(sender : UIButton)
    {
        //println(sender.tag.description)
        
        var refreshAlert = UIAlertController(title: "Confirm", message: "Do you want to delete this Meeting record ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Yes logic here")
            
            WebApiService.postMeetingAttendanceRecordDelete(LocalStore.accessToken()!, Id: sender.tag) { objectReturn in
                
                if let temp = objectReturn {
                    
                    if(temp.IsSuccess){
                        
                        self.InitData()
                    }
                    
                }
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Cancel Logic here")
        }))
        
        refreshAlert.view.tintColor = UIColor.blackColor()
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

    @IBAction func ButtonQuestionSetClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToQuestionSet", sender: sender)
    }
}
