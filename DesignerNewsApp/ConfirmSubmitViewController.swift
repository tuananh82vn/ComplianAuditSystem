//
//  ConfirmSubmitViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 17/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class ConfirmSubmitViewController: UIViewController , UIPopoverPresentationControllerDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var txt_Notes: UITextView!
    @IBOutlet weak var QuestionSetCompleted: UISwitch!
    @IBOutlet weak var MeetingRecordCompleted: UISwitch!
    @IBOutlet weak var AuditPlanCompleted: UISwitch!
    @IBOutlet weak var AuditDetailCompleted: UISwitch!
    @IBOutlet weak var BookingDetailCompleted: UISwitch!
    @IBOutlet weak var view1: UIView!
    
    var AuditOutcomeList = [AuditOutcomeModel]()
    var AuditConfirm = AuditActivityConfirmSubmitModel()
    var AuditHistoryList = [AuditActivityHistoryModel]()
    
    var selectedOutcomeId : Int = 0
    
    var userProfile = LoginModel()
    
    @IBOutlet weak var bt_Select: UIButton!
    
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    var keychain = Keychain()
    
    var OutcomeList = [String]()
    
    var selectOutcome : Int = 0
    
    var height: Int = 0
    
    var color = UIColor.blackColor()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint : NSLayoutConstraint!
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.viewWidthConstraint.constant = self.scrollView.frame.width
        self.view.layoutIfNeeded()
        
    }

    func InitData(){
        
        self.view.showLoading()
        
        WebApiService.getAuditActivityConfirmSubmitSelect(LocalStore.accessToken()! , AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()! ) { objectReturn in
            
            if let temp = objectReturn {
                
                self.AuditConfirm = temp

                self.AuditDetailCompleted.on =  self.AuditConfirm.IsAuditDetailsCompleted
               
                self.BookingDetailCompleted.on = self.AuditConfirm.IsBookingDetailsCompleted
               
                self.AuditPlanCompleted.on = self.AuditConfirm.IsAuditPlanCompleted
                
                self.MeetingRecordCompleted.on = self.AuditConfirm.IsMeetingAttendanceRecordCompleted
                
                self.QuestionSetCompleted.on = self.AuditConfirm.IsQuestionSetCompleted
                
                self.txt_Notes.text = self.AuditConfirm.Notes
                
                if(self.AuditConfirm.AuditOutcomeName == "") {
                    
                    self.bt_Select.setTitle("Select", forState: .Normal)

                }
                else
                {
                    
                    
                    if(self.AuditConfirm.AuditOutcomeColorName == "amber")
                    {
                        self.color = UIColor(rgba: "#FFC200")
                    }
                    else
                        if(self.AuditConfirm.AuditOutcomeColorName  == "blue")
                        {
                            self.color = UIColor(rgba: "#235396")
                        }
                        else
                            if(self.AuditConfirm.AuditOutcomeColorName  == "green")
                            {
                                self.color = UIColor(rgba: "#3EB55B")
                            }
                            else
                                if(self.AuditConfirm.AuditOutcomeColorName  == "red")
                                {
                                    self.color = UIColor(rgba: "#E32444")
                                }
                    
                    self.bt_Select.setTitle(self.AuditConfirm.AuditOutcomeName, forState: .Normal)
                    self.bt_Select.setTitleColor(self.color, forState: .Normal)
                    
                    self.selectedOutcomeId = self.AuditConfirm.AuditOutcomeId
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    WebApiService.getAuditOutcomeList(LocalStore.accessToken()!) { objectReturn in
                        
                        if let temp = objectReturn {
                            
                            self.AuditOutcomeList = temp
                            
                            var index = 0
                            
                            for temp in self.AuditOutcomeList {
                                self.OutcomeList.insert(temp.Name, atIndex: index)
                                index++
                            }
                            
                            WebApiService.getAuditActivityHistoryList(LocalStore.accessToken()! , AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()! ) { objectReturn in
                                
                                if let temp2 = objectReturn {
                                    
                                    self.view.hideLoading()
                                    
                                    self.AuditHistoryList = temp2
                                    
                                    self.height = (self.AuditHistoryList.count * 44)
                                    
                                    self.viewHeightConstraint.constant = CGFloat(self.height)
                                    
                                    self.view.layoutIfNeeded()
                                    
                                    self.scrollView.contentSize = CGSizeMake(self.tableView1.frame.width, CGFloat(self.height + 100))
                                    
                                    self.tableView1.reloadData()
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonSelectClicked(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: OutcomeList as [AnyObject] , initialSelection: self.selectOutcome, doneBlock: {
            picker, value, index in
            
            if(index != nil){
                if((index as! String) == "Amber")
                {
                    self.color = UIColor(rgba: "#FFC200")
                }
                else
                    if((index as! String)  == "Blue")
                    {
                        self.color = UIColor(rgba: "#235396")
                    }
                    else
                        if((index as! String)  == "Green")
                        {
                            self.color = UIColor(rgba: "#3EB55B")
                        }
                        else
                            if((index as! String)  == "Red")
                            {
                                self.color = UIColor(rgba: "#E32444")
                            }
            
                self.bt_Select.setTitle((index as! String), forState: .Normal)
                self.bt_Select.setTitleColor(self.color, forState: .Normal)
            
                self.selectOutcome =  value
                self.selectedOutcomeId = self.AuditOutcomeList[self.selectOutcome].Id
            }
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    func doSave(){
        var refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure to submit the audit ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            
            self.view.showLoading()
            
            self.AuditConfirm.IsAuditDetailsCompleted = self.AuditDetailCompleted.on
            
            self.AuditConfirm.IsBookingDetailsCompleted = self.BookingDetailCompleted.on
            
            self.AuditConfirm.IsAuditPlanCompleted = self.AuditPlanCompleted.on
            
            self.AuditConfirm.IsMeetingAttendanceRecordCompleted = self.MeetingRecordCompleted.on
            
            self.AuditConfirm.IsQuestionSetCompleted = self.QuestionSetCompleted.on
            
            self.AuditConfirm.Notes = self.txt_Notes.text
            
            self.AuditConfirm.AuditOutcomeId = self.selectedOutcomeId
            
            WebApiService.postAuditActivityConfirmSubmitEdit(LocalStore.accessToken()!, object : self.AuditConfirm) { objectReturn in
                
                if let temp = objectReturn {
                    
                    self.view.hideLoading()
                    
                    if(temp.IsSuccess){
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            WebApiService.loginWithUsername(self.keychain["username"]!, password: self.keychain["password"]!) { object in
                                
                                if let temp = object {
                                    
                                    self.userProfile = temp
                                    
                                    LocalStore.setToken(self.userProfile.TokenNumber)
                                    
                                    self.performSegueWithIdentifier("GoToActivity", sender: nil)
                                    
                                }
                            }
                        }
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
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        refreshAlert.view.tintColor = UIColor.blackColor()
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func ButtonSubmitClicked(sender: AnyObject) {
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.AuditHistoryList.count > 0 )
        {
            return self.AuditHistoryList.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //println("cellForRowAtIndexPath")
        
        var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("DetailCell") as! AuditHistoryTableViewCell
        
        cell1.lbl_Name.text = self.AuditHistoryList[indexPath.row].UserName
        cell1.lbl_Date.text = self.AuditHistoryList[indexPath.row].CreatedDateDisplay
        cell1.lbl_Status.text = self.AuditHistoryList[indexPath.row].AuditActivityStatusName
        cell1.lbl_Comment.text = self.AuditHistoryList[indexPath.row].Comment
        
        return cell1
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func rotated(){
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            
        }
        
        self.viewWidthConstraint.constant = self.scrollView.frame.width
        self.view.layoutIfNeeded()
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToActivity" {
            let GoToActivity = segue.destinationViewController as! AuditActivitiesViewController
            GoToActivity.userProfile = self.userProfile
        }
    }
}
