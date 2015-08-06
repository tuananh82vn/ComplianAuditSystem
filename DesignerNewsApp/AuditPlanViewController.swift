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
    private var auditPlanDetail = [AuditPlanDetailModel]()
    
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
        else if(tableView == self.tableDetail)
        {
            return self.auditPlanDetail.count
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.tableMaster){
            
            var cell1 = self.tableMaster.dequeueReusableCellWithIdentifier("MasterCell") as! AuditPlanMasterTableViewCell

            cell1.lbl_Title.text = self.auditPlanMaster[indexPath.row].DayTypeName + " - Day " +  self.auditPlanMaster[indexPath.row].DayNumber.description + " - " + self.auditPlanMaster[indexPath.row].DayDateDisplay

            return cell1
        }
        else
        {
            var cell2 = self.tableDetail.dequeueReusableCellWithIdentifier("DetailCell") as! AuditPlanDetailTableViewCell
            
            cell2.lbl_time.text = self.auditPlanDetail[indexPath.row].TimeText
            cell2.lbl_Activity.text = self.auditPlanDetail[indexPath.row].Activity
            cell2.lbl_Resources.text = self.auditPlanDetail[indexPath.row].ResoucesRequired
            
            return cell2

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableMaster){
            
            //println("You selected cell #\(self.auditPlanMaster[indexPath.row].AuditActivityDayId)!")
            
            self.auditPlanDetail.removeAll(keepCapacity: false)
            
            println("before : \(self.auditPlanDetail.count)")
            
            self.auditPlanDetail = GetDetailById(self.auditPlanMaster[indexPath.row].AuditActivityDayId)
            
            println("after : \(self.auditPlanDetail.count)")
            
            
            self.tableDetail.reloadData()
            
        }
    }
    
    func GetDetailById(DayId : Int ) -> [AuditPlanDetailModel] {
        
        var ReturnArray = [AuditPlanDetailModel]()
        
        for item in self.auditPlanList {
            
            if(item.AuditActivityDayId == DayId && item.AuditActivityAuditPlanId != 0){
            
                var temp = AuditPlanDetailModel()
                temp.AuditActivityAuditPlanId = item.AuditActivityAuditPlanId
                temp.TimeText = item.TimeText
                temp.Activity = item.Activity
                temp.ResoucesRequired = item.ResoucesRequired
                
                ReturnArray.append(temp)
                
            }
        }
        
        return ReturnArray
    }


}
