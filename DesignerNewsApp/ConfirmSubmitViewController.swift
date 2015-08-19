//
//  ConfirmSubmitViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 17/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitData()
        
        

        // Do any additional setup after loading the view.
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

                            self.createPicker()
                            
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
        picker.hidden ? openPicker() : closePicker()
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
    

    
    func createPicker()
    {
        
        var picker_height = self.AuditOutcomeList.count * 44 //+ self.properties.moods.count * 43
        picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: CGFloat(picker_height))
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        picker.layer.zPosition = 9000
        
        var offset = 21
        var index: Int
        
        for index = 0; index < self.AuditOutcomeList.count; ++index {

            let button = UIButton()
            button.frame = CGRect(x: 0, y: offset, width: Int(self.bt_Select.frame.width)  , height: 43)
            
            var color = UIColor.blackColor()
            
            if(self.AuditOutcomeList[index].Colour == "amber")
            {
                color = UIColor(rgba: "#FFC200")
            }
            else
                if(self.AuditOutcomeList[index].Colour == "blue")
                {
                    color = UIColor(rgba: "#235396")
                }
                else
                    if(self.AuditOutcomeList[index].Colour == "green")
                    {
                        color = UIColor(rgba: "#3EB55B")
                    }
                    else
                        if(self.AuditOutcomeList[index].Colour == "red")
                        {
                            color = UIColor(rgba: "#E32444")
                        }

            
            
            button.setTitleColor(color, forState: .Normal)
            button.setTitle(self.AuditOutcomeList[index].Name, forState: .Normal)
            button.tag = index
            button.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
            picker.addSubview(button)
            
            offset += 44
        }
        
        view1.addSubview(picker)
    }
    
    func ButtonEditClicked(sender : UIButton)
    {
        let temp = self.AuditOutcomeList[sender.tag].Name
        
        var color = UIColor.whiteColor()
        
        if(self.AuditOutcomeList[sender.tag].Colour == "amber")
        {
            color = UIColor(rgba: "#FFC200")
        }
        else
            if(self.AuditOutcomeList[sender.tag].Colour == "blue")
            {
                color = UIColor(rgba: "#235396")
            }
            else
                if(self.AuditOutcomeList[sender.tag].Colour == "green")
                {
                    color = UIColor(rgba: "#3EB55B")
                }
                else
                    if(self.AuditOutcomeList[sender.tag].Colour == "red")
                    {
                        color = UIColor(rgba: "#E32444")
        }
        
        self.selectedOutcomeId = self.AuditOutcomeList[sender.tag].Id
        
        self.bt_Select.setTitleColor(color, forState: .Normal)
        
        self.bt_Select.setTitle(temp, forState: .Normal)
        
        closePicker()
    }
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: 291)
                self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: 291)
                self.picker.alpha = 0
            },
            completion: { finished in
                self.picker.hidden = true
            }
        )
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToActivity" {
            let GoToActivity = segue.destinationViewController as! AuditActivitiesViewController
            GoToActivity.userProfile = self.userProfile
        }
    }
}
