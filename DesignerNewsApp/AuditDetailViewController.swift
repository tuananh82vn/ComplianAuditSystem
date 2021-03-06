//
//  AuditDetailViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class AuditDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var ButtonBooking: UIButton!
    @IBOutlet weak var ButtonEdit: UIBarButtonItem!
    
    @IBOutlet var tableView1: UITableView!
    @IBOutlet var tableView2: UITableView!


    @IBOutlet weak var lbl_SiteCompanyName: UILabel!
    @IBOutlet weak var lbl_SiteAddress: UILabel!
    
    @IBOutlet weak var lbl_Phone: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_LeadAuditor: UILabel!
    @IBOutlet weak var lbl_Scope: UILabel!
    @IBOutlet weak var lbl_AuditType: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    
    private var auditSiteDetail = AuditActivitySiteDetailModel()
    
    private var auditActivityAuditDetail = AuditActivityAuditDetailModel()

    
    @IBOutlet weak var btb_Title: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false

        
        btb_Title.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btb_Title.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btb_Title.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        
        //Check Internet
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    self.initData()
                }
                else
                {
                    var customIcon = UIImage(named: "no-internet")
                    var alertview = JSSAlertView().show2(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                    alertview.setTextTheme(.Light)
                }
        })
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refeshAuditDetail", object: nil)


    }
    

    func initData(){
        
        self.view.showLoading()
        
        self.ButtonEdit.enabled = false

        WebApiService.getAuditActivitySiteDetail(LocalStore.accessToken()!, AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()!) { objectReturn1 in
            
            if let temp1 = objectReturn1 {
                
                self.auditSiteDetail = temp1
                
                // 3
                let NavView = UIView(frame: CGRect(x: 0, y: 0, width: 689, height: 40))
                NavView.contentMode = .ScaleAspectFit
                NavView.backgroundColor = UIColor.blackColor()
                
                let lbl_SiteName = UILabel(frame: CGRect(x: 0, y: 0, width: 680, height: 18))
                lbl_SiteName.textAlignment = NSTextAlignment.Left
                lbl_SiteName.text = self.auditSiteDetail.SiteName
                lbl_SiteName.textColor = UIColor.whiteColor()
                lbl_SiteName.font = UIFont (name: "HelveticaNeue-Bold", size: 12)
                
                let lbl_SiteAddress = UILabel(frame: CGRect(x: 0, y: 20, width: 680, height: 18))
                lbl_SiteAddress.textAlignment = NSTextAlignment.Left
                lbl_SiteAddress.text = self.auditSiteDetail.SiteAddress + ", " + self.auditSiteDetail.SiteSuburb + ", "  + self.auditSiteDetail.SiteState + ", "  + self.auditSiteDetail.SitePostCode

                lbl_SiteAddress.textColor = UIColor.whiteColor()
                lbl_SiteAddress.font = UIFont (name: "HelveticaNeue", size: 12)
                
                NavView.addSubview(lbl_SiteName)
                NavView.addSubview(lbl_SiteAddress)
                
                // 5
                self.navigationItem.titleView = NavView
                
                keychain["SiteName"] = self.auditSiteDetail.SiteName
                keychain["SiteAddress"] = self.auditSiteDetail.SiteAddress + ", " + self.auditSiteDetail.SiteSuburb + ", "  + self.auditSiteDetail.SiteState + ", "  + self.auditSiteDetail.SitePostCode

                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    WebApiService.getAuditActivityAuditDetail(LocalStore.accessToken()!, AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()!) { objectReturn2 in
                        
                        if let temp2 = objectReturn2 {
                            
                            self.auditActivityAuditDetail = temp2
                            
                            self.lbl_FromDate.text = self.auditActivityAuditDetail.AuditStartDateDisplay
                            
                            self.lbl_ToDate.text = self.auditActivityAuditDetail.AuditEndDateDisplay
                            
                            self.lbl_AuditType.text = self.auditActivityAuditDetail.AuditType
                            
                            self.lbl_Scope.text = self.auditActivityAuditDetail.ScopeOfAudit
                            
                            self.lbl_LeadAuditor.text = self.auditActivityAuditDetail.LeadAuditor
                            
                            self.lbl_Phone.text = self.auditActivityAuditDetail.Phone
                            
                            self.lbl_Email.text = self.auditActivityAuditDetail.EmailAddress
                            
                            self.tableView1.reloadData()
                            
                            self.tableView2.reloadData()
                            
                            self.view.hideLoading()
                            
                            self.ButtonEdit.enabled = true
                            
                        }
                    }
                
                }
                
            }
            
        }

    }

    
    func refesh(notification: NSNotification){
        self.initData()
    }
    
    
    @IBAction func ButtonEditClicked(sender: AnyObject) {
        
        self.performSegueWithIdentifier("GotoAuditDetailEdit", sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableView1){
            return self.auditActivityAuditDetail.TimeOnFactoryFloor.count
        }
        else
            {
                return self.auditActivityAuditDetail.TimeOnSite.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.tableView1){
            var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("DetailCell1") as! AuditRequestDetailViewCell
        
            
            if let TimeOnFactoryFloor = self.auditActivityAuditDetail.TimeOnFactoryFloor[indexPath.row] {
                
                cell1.lbl_Number.text =  TimeOnFactoryFloor.DayNumber.description
                cell1.lbl_Day.text =  TimeOnFactoryFloor.DayDateDisplay
            }
            
            return cell1
        }
        else
            {
                var cell2 = self.tableView2.dequeueReusableCellWithIdentifier("DetailCell2") as! AuditRequestDetailViewCell
            
                if let TimeOnSite = self.auditActivityAuditDetail.TimeOnSite[indexPath.row] {
                    cell2.lbl_Number.text =  TimeOnSite.DayNumber.description
                    cell2.lbl_Day.text =  TimeOnSite.DayDateDisplay
                }
                
                return cell2
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GotoAuditDetailEdit" {
            let auditDetailEditViewController = segue.destinationViewController as! AuditDetailEditViewController
            auditDetailEditViewController.auditActivityDetail = self.auditActivityAuditDetail
        }
        else
                if segue.identifier == "GoBackToActivity" {

                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = kCATransitionPush
                    transition.subtype = kCATransitionFromLeft
                    self.navigationController!.view.layer.addAnimation(transition, forKey: nil)
                    //self.navigationController?.popViewControllerAnimated(false)
        }
    }

    @IBAction func ButtonBookingClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToBooking", sender: sender)
    }
    
    @IBAction func ButtonHomeClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoBackToActivity", sender: sender)
    }
    @IBAction func ButtonTitleClicked(sender: AnyObject) {
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: ScreenList as [AnyObject] , initialSelection: 0, doneBlock: {
            picker, value, index in

            if(value == 1)
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
                self.performSegueWithIdentifier("GoToQuestion", sender: nil)
            }
            else if(value == 5)
            {
                self.performSegueWithIdentifier("GoToSubmit", sender: nil)
            }

            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController!.viewControllers.removeAtIndex(0)
    }

}
