//
//  ConfirmSubmitViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 17/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class ConfirmSubmitViewController: UIViewController , UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var txt_Notes: UITextView!
    @IBOutlet weak var QuestionSetCompleted: UISwitch!
    @IBOutlet weak var MeetingRecordCompleted: UISwitch!
    @IBOutlet weak var AuditPlanCompleted: UISwitch!
    @IBOutlet weak var AuditDetailCompleted: UISwitch!
    @IBOutlet weak var BookingDetailCompleted: UISwitch!
    @IBOutlet weak var view1: UIView!
    
    var AuditOutcomeList = [AuditOutcomeModel]()
    var AuditConfirm = AuditActivityConfirmSubmitModel()
    var selectedOutcomeId : Int = 0
    
    var userProfile = LoginModel()
    
    @IBOutlet weak var bt_Select: UIButton!
    
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    var keychain = Keychain()
    
    var OutcomeList = [String]()
    
    var selectOutcome : Int = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        InitData()

    }

    func InitData(){
        view.showLoading()
        
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
                    self.bt_Select.setTitle(self.AuditConfirm.AuditOutcomeName, forState: .Normal)
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


                            self.view.hideLoading()
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
            
            self.bt_Select.setTitle(index as! String, forState: .Normal)
            self.selectOutcome =  value
            self.selectedOutcomeId = self.AuditOutcomeList[self.selectOutcome].Id
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }

    @IBAction func ButtonSubmitClicked(sender: AnyObject) {
        
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
                                            
                                                self.performSegueWithIdentifier("GoToActivity", sender: sender)
                                            
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

    
//    func ButtonEditClicked(sender : UIButton)
//    {
//        let temp = self.AuditOutcomeList[sender.tag].Name
//        
//        var color = UIColor.whiteColor()
//        
//        if(self.AuditOutcomeList[sender.tag].Colour == "amber")
//        {
//            color = UIColor(rgba: "#FFC200")
//        }
//        else
//            if(self.AuditOutcomeList[sender.tag].Colour == "blue")
//            {
//                color = UIColor(rgba: "#235396")
//            }
//            else
//                if(self.AuditOutcomeList[sender.tag].Colour == "green")
//                {
//                    color = UIColor(rgba: "#3EB55B")
//                }
//                else
//                    if(self.AuditOutcomeList[sender.tag].Colour == "red")
//                    {
//                        color = UIColor(rgba: "#E32444")
//        }
//        
//        self.selectedOutcomeId = self.AuditOutcomeList[sender.tag].Id
//        
//        self.bt_Select.setTitleColor(color, forState: .Normal)
//        
//        self.bt_Select.setTitle(temp, forState: .Normal)
//        
//        closePicker()
//    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToActivity" {
            let GoToActivity = segue.destinationViewController as! AuditActivitiesViewController
            GoToActivity.userProfile = self.userProfile
        }
    }
}
