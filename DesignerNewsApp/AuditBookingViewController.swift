//
//  AuditBookingViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditBookingViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView1: UITableView!
    
    var AuditActivityUrlId : String!
    
    private var auditBooking = [AuditActivityBookingDetaiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //println(AuditActivityUrlId)
        
        InitData()
        
        // Do any additional setup after loading the view.
    }

    func InitData(){
        
        view.showLoading()
        
        WebApiService.getAuditActivityBookingDetailList(LocalStore.accessToken()!, AuditActivityUrlId: AuditActivityUrlId) { objectReturn in
            
            if let temp = objectReturn {
            
                self.auditBooking = temp
                
                self.tableView1.reloadData()
                
                self.view.hideLoading()
            
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return auditBooking.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("BookingCell") as! BookingViewCell
        
            cell1.lbl_Number.text = (indexPath.row+1).description
        
            cell1.lbl_Item.text = self.auditBooking[indexPath.row].Item
        
            cell1.lbl_Notes.text = self.auditBooking[indexPath.row].Notes
        
            cell1.lbl_FileName.text = self.auditBooking[indexPath.row].FileName
        
        
            return cell1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell #\(indexPath.row)!")
    }
    @IBAction func ButtonAddClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToBookingAdd", sender: sender)

    }
}
