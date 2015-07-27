//
//  AuditDetailViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 23/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var tableView: UITableView!
    
    var items: [String] = ["We", "Heart", "Swift"]
    
    
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
    
    
    var AuditActivityUrlId : String!
    var originalCenter: CGPoint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        originalCenter = view.center
        
        initSiteData()
        
        initDetailData()
        
        

        // Do any additional setup after loading the view.
    }


    

    func initSiteData(){
        
        view.showLoading()
        
        WebApiService.getAuditActivitySiteDetail(LocalStore.accessToken()!, AuditActivityUrlId : self.AuditActivityUrlId) { objectReturn in
            
            self.view.hideLoading()
            
            if let temp = objectReturn {

                self.auditSiteDetail = temp
            
                self.lbl_SiteDetailName.text = self.auditSiteDetail.SiteName
                self.lbl_SiteIndustryName.text = self.auditSiteDetail.SiteIndustryTypeName
                self.lbl_SiteCompanyName.text = self.auditSiteDetail.SiteCompanyName
                
            }
            
        }

    }
    
    func initDetailData(){
        
        view.showLoading()
        
        WebApiService.getAuditActivityAuditDetail(LocalStore.accessToken()!, AuditActivityUrlId : self.AuditActivityUrlId) { objectReturn in
            
            self.view.hideLoading()
            
            if let temp = objectReturn {
                
                self.auditActivityAuditDetail = temp
                
                self.lbl_FromDate.text = self.auditActivityAuditDetail.AuditStartDateDisplay
                
                self.lbl_ToDate.text = self.auditActivityAuditDetail.AuditEndDateDisplay
                
                self.lbl_AuditType.text = self.auditActivityAuditDetail.AuditType
                
                self.lbl_Scope.text = self.auditActivityAuditDetail.ScopeOfAudit
                
                self.lbl_LeadAuditor.text = self.auditActivityAuditDetail.LeadAuditor
                
                self.lbl_Phone.text = self.auditActivityAuditDetail.Phone
                
                self.lbl_Email.text = self.auditActivityAuditDetail.EmailAddress
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.auditActivityAuditDetail.ListAuditActivityDay.count)
        return self.auditActivityAuditDetail.ListAuditActivityDay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("DetailCell") as! AuditRequestDetailViewCell
        
        cell.lbl_Number.text =  self.auditActivityAuditDetail.ListAuditActivityDay[indexPath.row].DayNumber.description
        cell.lbl_Day.text =  self.auditActivityAuditDetail.ListAuditActivityDay[indexPath.row].DayDateDisplay
        
        println("numberOfRowsInSection \(indexPath.row)")
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell #\(indexPath.row)!")
    }


}
