//
//  AuditPlanViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 6/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditPlanViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableMaster: UITableView!
    
    @IBOutlet weak var tableDetail: UITableView!
    private var auditPlanList = [AuditActivityAuditPlanModel]()
    
    private var auditPlanMaster = [AuditPlanMasterModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitData()
    }

    
    func InitData(){
    
        view.showLoading()
        
        WebApiService.getAuditActivityAudtiPlanList(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
            
            if let temp = objectReturn {
                
                self.auditPlanList = temp
                
                self.auditPlanMaster = self.ConvertToAuditPlanMaster(self.auditPlanList)
                
                self.view.hideLoading()
                
                self.tableMaster.reloadData()
                
            }
        }

    }
    
    func ConvertToAuditPlanMaster(auditPlanList : [AuditActivityAuditPlanModel]) -> [AuditPlanMasterModel] {
        
        var ReturnArray = [AuditPlanMasterModel]()
        
        
        
        for item in auditPlanList {
            
            var SingleObject = AuditPlanMasterModel()
            
            SingleObject.DayTypeName = item.DayTypeName
            SingleObject.DayNumber = item.DayNumber
            SingleObject.DayDateDisplay = item.DayDateDsiplay
            SingleObject.AuditActivityDayId = item.AuditActivityDayId
            
            if (CheckExistInArray(SingleObject, arrayObject: ReturnArray)){
                ReturnArray.append(SingleObject)
            }
        }
        
        return ReturnArray
    }
    
    func CheckExistInArray(singleObject : AuditPlanMasterModel, arrayObject : [AuditPlanMasterModel]) -> Bool {
        
        for item in arrayObject {
            if item.AuditActivityDayId == singleObject.AuditActivityDayId
            {
                return false
            }
        }
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.tableMaster){
            return self.auditPlanMaster.count
        }
        else
        {
            return self.auditPlanMaster.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.tableMaster){
            
            var cell1 = self.tableMaster.dequeueReusableCellWithIdentifier("MasterCell") as! AuditPlanMasterTableViewCell

            cell1.lbl_Title.text = self.auditPlanMaster[indexPath.row].DayTypeName + " - Day " +  self.auditPlanMaster[indexPath.row].DayNumber.description + " - " + self.auditPlanMaster[indexPath.row].DayDateDisplay

            return cell1
        }
        else
        {
        
                var cell2 = self.tableMaster.dequeueReusableCellWithIdentifier("DetailCell") as! AuditPlanDetailTableViewCell
                return cell2

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableMaster){
            println("You selected cell #\(self.auditPlanMaster[indexPath.row].AuditActivityDayId)!")
        }
    }


}
