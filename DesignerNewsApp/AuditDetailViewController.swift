//
//  AuditDetailViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var ButtonBooking: UIButton!
    @IBOutlet weak var ButtonEdit: UIBarButtonItem!
    
    @IBOutlet var tableView1: UITableView!
    
    @IBOutlet var tableView2: UITableView!

    @IBOutlet weak var lbl_SiteDetailName: UILabel!
    @IBOutlet weak var lbl_SiteIndustryName: UILabel!
    @IBOutlet weak var lbl_SiteCompanyName: UILabel!
    @IBOutlet weak var lbl_Phone: UILabel!
    @IBOutlet weak var lbl_Email: UILabel!
    @IBOutlet weak var lbl_LeadAuditor: UILabel!
    @IBOutlet weak var lbl_Scope: UILabel!
    @IBOutlet weak var lbl_AuditType: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    
    private var auditSiteDetail = AuditActivitySiteDetailModel()
    
    private var auditActivityAuditDetail = AuditActivityAuditDetailModel()
    
    
   // var AuditActivityUrlId : String!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        initSiteData()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refeshAuditDetail", object: nil)


        // Do any additional setup after loading the view.
    }

    func initSiteData(){
        
        view.showLoading()
        
        self.ButtonEdit.enabled = false

        WebApiService.getAuditActivitySiteDetail(LocalStore.accessToken()!, AuditActivityUrlId : LocalStore.accessAuditActivityUrlId()!) { objectReturn1 in
            
            if let temp1 = objectReturn1 {
                
                self.auditSiteDetail = temp1
                self.lbl_SiteDetailName.text = self.auditSiteDetail.SiteName
                self.lbl_SiteIndustryName.text = self.auditSiteDetail.SiteIndustryTypeName
                self.lbl_SiteCompanyName.text = self.auditSiteDetail.SiteCompanyName
                
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
        initSiteData()
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
            if segue.identifier == "GoToBooking" {
//                let auditBookingViewController = segue.destinationViewController as! AuditBookingViewController
//                auditBookingViewController.AuditActivityUrlId = self.AuditActivityUrlId
        }
    }

    @IBAction func ButtonBookingClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToBooking", sender: sender)
    }

}
