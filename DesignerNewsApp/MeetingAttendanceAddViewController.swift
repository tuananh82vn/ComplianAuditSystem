//
//  MeetingAttendanceAddViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MeetingAttendanceAddViewController: UIViewController {

    @IBOutlet weak var txt_Close: UITextField!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_Open: UITextField!
    @IBOutlet weak var txt_Position: UITextField!
    @IBOutlet weak var txt_Name: UITextField!
    
    var MeetingRecord = AuditActivityMeetingAttendanceRecordModel()
    
    var selectedId : Int = 0
    
    var AddMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(AddMode)
        {
            self.lbl_Title.text = "Add Meeting Attendance Record"
            
        }
        else
        {
            self.lbl_Title.text = "Edit Meeting Attendance Record"
            
            InitData()
        }
    }
    
    func InitData(){
        
        WebApiService.getAuditActivityMeetingAttendanceRecordModel(LocalStore.accessToken()!, Id: selectedId) { objectReturn in
            
            if let temp = objectReturn {
                
                self.MeetingRecord = temp
                
                self.txt_Name.text = self.MeetingRecord.Name
                self.txt_Position.text = self.MeetingRecord.Position
                self.txt_Open.text = self.MeetingRecord.SignOpenMeeting
                self.txt_Close.text = self.MeetingRecord.SignCloseMeeting
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonCancelClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        view.showLoading()
        
        self.MeetingRecord.Id = self.selectedId
        
        self.MeetingRecord.AuditActivityUrlId = LocalStore.accessAuditActivityUrlId()!
        
        self.MeetingRecord.Name = self.txt_Name.text
        
        self.MeetingRecord.Position = self.txt_Position.text
        
        self.MeetingRecord.SignOpenMeeting = self.txt_Open.text
        
        self.MeetingRecord.SignCloseMeeting = self.txt_Close.text
        
        WebApiService.postAuditActivityMeetingAttendanceRecord(LocalStore.accessToken()!, MeetingRecord: self.MeetingRecord , AddMode: AddMode) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("refeshMeeting", object: nil)

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
