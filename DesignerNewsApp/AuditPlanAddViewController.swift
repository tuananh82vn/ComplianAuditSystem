//
//  AuditPlanAddViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 6/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class AuditPlanAddViewController: UIViewController {

    var addMode : Bool = false
    
    @IBOutlet weak var bt_Time: UIButton!
    var selectedDayId : Int = 0
    var selectedAuditActivityId : Int = 0
    var selectedAuditPlanId : Int = 0
    var LastSelected =  NSIndexPath()
    
    var AuditPlanItem = AuditActivityAuditPlanModel()
    
    @IBOutlet weak var lbl_Title: UILabel!
    

    @IBOutlet weak var tf_Resource: UITextView!

    @IBOutlet weak var tf_Activity: UITextView!
    
    @IBOutlet weak var tf_Time: UITextField!
    
    @IBAction func TimeSelected(sender: AnyObject) {
        
        var datePicker = ActionSheetDatePicker(title: "Time:", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), target: self, action: "datePicked:", origin: sender)
        
        datePicker.minuteInterval = 20
        
        datePicker.showActionSheetPicker()
    }
    
    func datePicked(obj: NSDate) {
        self.bt_Time.setTitle(obj.toShortTimeString(), forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(addMode)
        {
            self.lbl_Title.text = "Add Audit Plan Detail"
            
        }
        else
        {
            self.lbl_Title.text = "Edit Audit Plan Detail"
            
            InitData()
        }

    }

    func InitData() {
        
        WebApiService.getAuditActivityAuditPlan(LocalStore.accessToken()!, Id: selectedAuditPlanId) { objectReturn in
            
            if let temp = objectReturn {
                
                self.AuditPlanItem = temp
               
                self.tf_Activity.text = self.AuditPlanItem.Activity
                self.tf_Resource.text = self.AuditPlanItem.ResoucesRequired
                self.bt_Time.setTitle(self.AuditPlanItem.TimeText , forState: UIControlState.Normal)

            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doSave(){
        view.showLoading()
        
        self.AuditPlanItem.AuditActivityAuditPlanId = self.selectedAuditPlanId
        
        self.AuditPlanItem.AuditActivityId = self.selectedAuditActivityId
        
        self.AuditPlanItem.AuditActivityDayId = self.selectedDayId
        
        if let text = self.bt_Time.titleLabel?.text {
            self.AuditPlanItem.TimeText = text
        }
        
        self.AuditPlanItem.Activity = self.tf_Activity.text
        
        self.AuditPlanItem.ResoucesRequired = self.tf_Resource.text
        
        WebApiService.postAuditActivityAuditPlanAdd(LocalStore.accessToken()!, object: self.AuditPlanItem, type : self.addMode) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){
                    
                    var temp = ["selectedDayId" : self.selectedDayId,  "LastSelected" : self.LastSelected]
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("refeshAuditPlan", object: nil, userInfo: temp)
                    
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

    @IBAction func ButtonCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
