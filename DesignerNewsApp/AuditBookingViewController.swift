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
    
    var SelectedId : Int = 0
    
    private var auditBooking = [AuditActivityBookingDetaiModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refeshBooking", object: nil)
    }

    func InitData(){
        
        view.showLoading()
        
        WebApiService.getAuditActivityBookingDetailList(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
            
            if let temp = objectReturn {
                
                //println("init data")
            
                self.auditBooking = temp
                
                self.tableView1.reloadData()
                
                self.view.hideLoading()
            
            }
        }
        
        
    }
    
    func refesh(notification: NSNotification){
        InitData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return auditBooking.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            var cell = self.tableView1.dequeueReusableCellWithIdentifier("BookingCell") as! BookingViewCell
        
            cell.lbl_Number.text = (indexPath.row+1).description
        
            cell.lbl_Item.text = self.auditBooking[indexPath.row].Item
        
            cell.lbl_Notes.text = self.auditBooking[indexPath.row].Notes
        
            cell.lbl_FileName.text = self.auditBooking[indexPath.row].FileName
        
            cell.ButtonDelete.tag = self.auditBooking[indexPath.row].Id
        
            cell.ButtonDelete.addTarget(self, action: "ButtonDeleteClicked:", forControlEvents: .TouchUpInside)

            cell.ButtonEdit.tag = self.auditBooking[indexPath.row].Id
        
            cell.ButtonEdit.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
        
            if self.auditBooking[indexPath.row].FileId == 0 {
                cell.ButtonDownload.hidden = true
            }
            else
            {
                cell.ButtonDownload.hidden = false
                
                cell.ButtonDownload.tag = self.auditBooking[indexPath.row].FileId
        
                cell.ButtonDownload.addTarget(self, action: "ButtonDownloadClicked:", forControlEvents: .TouchUpInside)
            }
        

            return cell
    }
    
    func ButtonDownloadClicked(sender : UIButton)
    {
        
        WebApiService.getFile(sender.tag) { objectReturn in

            self.performSegueWithIdentifier("GoToWebviewer", sender: objectReturn)
        }
    }
    
    func ButtonEditClicked(sender : UIButton)
    {
        self.SelectedId = sender.tag
        
        self.performSegueWithIdentifier("GoToBookingEdit", sender: sender)
    }
    
    func ButtonDeleteClicked(sender : UIButton)
    {
        //println(sender.tag.description)
        
        var refreshAlert = UIAlertController(title: "Confirm", message: "Do you want to delete this booking item ?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Yes logic here")
            
            WebApiService.postAuditActivityBookingDetailDelete(LocalStore.accessToken()!, Id: sender.tag) { objectReturn in
                
                if let temp = objectReturn {
                    
                    if(temp.IsSuccess){
                        
                        self.InitData()
                    }
                    
                }
            }

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Cancel Logic here")
        }))
        
        refreshAlert.view.tintColor = UIColor.blackColor()

        self.presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell #\(indexPath.row)!")
    }
    @IBAction func ButtonAddClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToBookingAdd", sender: sender)

    }
    
    @IBAction func ButtonAuditPlanClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToAuditPlan", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToBookingAdd" {
                        let controller = segue.destinationViewController as! AuditBookingAddViewController
                        controller.AddMode = true
        }
        else
        if segue.identifier == "GoToBookingEdit" {
            let controller = segue.destinationViewController as! AuditBookingAddViewController
            controller.AddMode = false
            controller.selectedBookingId = self.SelectedId
        }
        else
            if segue.identifier == "GoToWebviewer" {
                
                UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
                
                let webViewController = segue.destinationViewController as! WebViewController

                if let url = sender as? NSURL {
                    webViewController.url = url
                }
        }
        
    }
}
