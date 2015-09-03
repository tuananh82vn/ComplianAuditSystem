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

    @IBOutlet weak var btb_Title: UIButton!
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
        
        btb_Title.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btb_Title.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btb_Title.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
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
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController!.viewControllers.removeAtIndex(0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // 3
        let NavView = UIView(frame: CGRect(x: 0, y: 0, width: 689, height: 40))
        NavView.contentMode = .ScaleAspectFit
        NavView.backgroundColor = UIColor.blackColor()
        
        let lbl_SiteName = UILabel(frame: CGRect(x: 0, y: 0, width: 680, height: 18))
        lbl_SiteName.textAlignment = NSTextAlignment.Left
        lbl_SiteName.text = keychain["SiteName"]
        lbl_SiteName.textColor = UIColor.whiteColor()
        lbl_SiteName.font = UIFont (name: "HelveticaNeue-Bold", size: 12)
        
        let lbl_SiteAddress = UILabel(frame: CGRect(x: 0, y: 20, width: 680, height: 18))
        lbl_SiteAddress.textAlignment = NSTextAlignment.Left
        lbl_SiteAddress.text = keychain["SiteAddress"]
        
        lbl_SiteAddress.textColor = UIColor.whiteColor()
        lbl_SiteAddress.font = UIFont (name: "HelveticaNeue", size: 12)
        
        NavView.addSubview(lbl_SiteName)
        NavView.addSubview(lbl_SiteAddress)
        
        // 5
        self.navigationItem.titleView = NavView
        
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
    
    func doSave()
    {
        var alertview = JSSAlertView().show2(self, title: "Confirm", text: "Are you sure to submit the audit?", buttonText: "Yes", cancelButtonText: "No", color: UIColorFromHex(0xf1c40f, alpha: 1))
        alertview.setTextTheme(.Light)
        alertview.addAction(yesSubmitCallBack)
    }
    
    @IBAction func ButtonDoneClicked(sender: AnyObject) {
        
        var alertview = JSSAlertView().show2(self, title: "Notice", text: "Go back to home screen without submit?", buttonText: "Yes", cancelButtonText: "No", color: UIColorFromHex(0x3498db, alpha: 1))
        alertview.setTextTheme(.Light)
        alertview.addAction(yesDoneCallback)
    }
    
    func yesDoneCallback() {
        
                
                self.performSegueWithIdentifier("GoBackToAuditActivity", sender: nil)
        
    }
    
    func yesSubmitCallBack(){
        
        self.view.showLoading()
        
        self.AuditConfirm.IsAuditDetailsCompleted = self.AuditDetailCompleted.on
        
        self.AuditConfirm.IsBookingDetailsCompleted = self.BookingDetailCompleted.on
        
        self.AuditConfirm.IsAuditPlanCompleted = self.AuditPlanCompleted.on
        
        self.AuditConfirm.IsMeetingAttendanceRecordCompleted = self.MeetingRecordCompleted.on
        
        self.AuditConfirm.IsQuestionSetCompleted = self.QuestionSetCompleted.on
        
        self.AuditConfirm.Notes = self.txt_Notes.text
        if (self.selectedOutcomeId != 0)
        {
            self.AuditConfirm.AuditOutcomeId = self.selectedOutcomeId
        }
        else
        {
            self.AuditConfirm.AuditOutcomeId = nil
        }
        
        WebApiService.postAuditActivityConfirmSubmitEdit(LocalStore.accessToken()!, object : self.AuditConfirm) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){

                   self.performSegueWithIdentifier("GoBackToAuditActivity", sender: nil)

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

    @IBAction func ButtonHomeClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoBackToAuditActivity", sender: sender)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoBackToQuestion" {
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
        }
        else
            if segue.identifier == "GoBackToAuditActivity" {
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromTop
                self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
        }
    }
    @IBAction func ButtonTitleClicked(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: ScreenList as [AnyObject] , initialSelection: 5, doneBlock: {
            picker, value, index in
            
            if(value == 0)
            {
                self.performSegueWithIdentifier("GoToAuditDetail", sender: nil)
            }
            else if(value == 1)
            {
                self.performSegueWithIdentifier("GoToBooking", sender: nil)
            }
            else if(value == 2)
            {
                self.performSegueWithIdentifier("GoToAuditPlan", sender: nil)
            }
            else if(value == 3)
            {
                self.performSegueWithIdentifier("GoToMeeting", sender: nil)
            }
            else if(value == 4)
            {
                self.performSegueWithIdentifier("GoBackToQuestion", sender: nil)
            }
            
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    @IBAction func ButtonBackClicked(sender: AnyObject) {
         self.performSegueWithIdentifier("GoBackToQuestion", sender: nil)
    }
}
