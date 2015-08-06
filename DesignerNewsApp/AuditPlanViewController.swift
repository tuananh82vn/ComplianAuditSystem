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
    
    private var auditPlanList   = [AuditActivityAuditPlanModel]()
    private var auditPlanMaster = [AuditPlanMasterModel]()
    private var auditPlanDetail = [AuditPlanDetailModel]()
    
    var selectedDayId : Int = 0
    var selectedActivityId : Int = 0
    var selectedAuditPlanId : Int = 0
    
    var LastSelected :  NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refesh", object: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToAuditPlanAdd" {
            let controller = segue.destinationViewController as! AuditPlanAddViewController
            
            controller.selectedAuditActivityId = self.selectedActivityId
            controller.selectedDayId = self.selectedDayId
            controller.addMode = true
            controller.LastSelected = self.LastSelected!
            
        }
        else
            if segue.identifier == "GoToAuditPlanEdit" {
                let controller = segue.destinationViewController as! AuditPlanAddViewController
                
                controller.selectedAuditActivityId = self.selectedActivityId
                controller.selectedDayId = self.selectedDayId
                controller.addMode = false
                controller.LastSelected = self.LastSelected!
                controller.selectedAuditPlanId = self.selectedAuditPlanId
        }
        
        
    }
    
    func refesh(notification: NSNotification){
        
        view.showLoading()
        
        WebApiService.getAuditActivityAudtiPlanList(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
            
            if let temp = objectReturn {
                
                self.auditPlanList = temp
                
                self.auditPlanMaster = self.ConvertToAuditPlanMaster(self.auditPlanList)
                
                self.selectedDayId = notification.userInfo!["selectedDayId"] as! Int
                
                self.LastSelected = notification.userInfo!["LastSelected"] as! NSIndexPath
                
                
                //reload data
                self.auditPlanDetail.removeAll(keepCapacity: false)
                
                self.auditPlanDetail = self.GetPlanDetailById(self.selectedDayId)
                
                self.tableMaster.reloadData()
                
                self.tableDetail.reloadData()
                
                
                //set selected row
                self.tableMaster.cellForRowAtIndexPath(self.LastSelected!)?.selected = true
                
                
                self.view.hideLoading()
            }
        }
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
            SingleObject.AuditActivityId = item.AuditActivityId
            
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
            
            cell2.bt_Delete.tag = self.auditPlanDetail[indexPath.row].AuditActivityAuditPlanId
            cell2.bt_Delete.addTarget(self, action: "ButtonDeleteClicked:", forControlEvents: .TouchUpInside)
            
            cell2.bt_Edit.tag = self.auditPlanDetail[indexPath.row].AuditActivityAuditPlanId
            cell2.bt_Edit.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
            
            return cell2

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.tableMaster){
            
            self.selectedDayId = self.auditPlanMaster[indexPath.row].AuditActivityDayId
            
            self.selectedActivityId = self.auditPlanMaster[indexPath.row].AuditActivityId
            
            self.auditPlanDetail.removeAll(keepCapacity: false)

            self.auditPlanDetail = GetPlanDetailById(self.auditPlanMaster[indexPath.row].AuditActivityDayId)

            if let selected = self.LastSelected {
               tableView.cellForRowAtIndexPath(selected)?.selected = false
            }
            
            
            
            //set row selected
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            self.LastSelected = indexPath
            
            //println("Selected : \(self.LastSelected)")
            
            self.tableDetail.reloadData()
            
        }
    }
    
    func GetPlanDetailById(AuditActivityDayId : Int ) -> [AuditPlanDetailModel] {
        
        var ReturnArray = [AuditPlanDetailModel]()
        
        for item in self.auditPlanList {
            
            if(item.AuditActivityDayId == AuditActivityDayId && item.AuditActivityAuditPlanId != 0){
            
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

    @IBAction func ButtonAddClicked(sender: AnyObject) {
        if (self.selectedDayId == 0 && self.selectedActivityId == 0) {
        
            var alert = UIAlertController(title: "Error", message: "Please select atleast one day first", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.view.tintColor = UIColor.blackColor()
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        else
        {
            self.performSegueWithIdentifier("GoToAuditPlanAdd", sender: sender)
        }
    }
    
    func ButtonDeleteClicked(sender : UIButton){
        //println(sender.tag.description)
        
        var refreshAlert = UIAlertController(title: "Confirm", message: "Do you want to delete this item ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            WebApiService.postAuditActivityAuditPlanDelete(LocalStore.accessToken()!, Id: sender.tag) { objectReturn in
                
                if let temp = objectReturn {
                    
                    if(temp.IsSuccess){
                        
                        self.view.showLoading()
                        
                        WebApiService.getAuditActivityAudtiPlanList(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
                            
                            if let temp = objectReturn {
                                
                                self.auditPlanList = temp
                                
                                self.auditPlanMaster = self.ConvertToAuditPlanMaster(self.auditPlanList)
                                
                                self.auditPlanDetail.removeAll(keepCapacity: false)
                                
                                self.auditPlanDetail = self.GetPlanDetailById(self.selectedDayId)
                                
                                self.tableMaster.reloadData()
                                
                                self.tableDetail.reloadData()
                                
                                //set selected row
                                self.tableMaster.cellForRowAtIndexPath(self.LastSelected!)?.selected = true
                                
                                self.view.hideLoading()
                            }
                        }

                    }
                    
                }
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        refreshAlert.view.tintColor = UIColor.blackColor()
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    func ButtonEditClicked(sender : UIButton){
        //println(sender.tag.description)
        self.selectedAuditPlanId = sender.tag
        
        self.performSegueWithIdentifier("GoToAuditPlanEdit", sender: sender)
        
    }

}
