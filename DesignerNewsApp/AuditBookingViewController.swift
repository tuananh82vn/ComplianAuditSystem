//
//  AuditBookingViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import CoreActionSheetPicker

class AuditBookingViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btb_Title: UIButton!
    @IBOutlet weak var tableView1: UITableView!
    
    var SelectedId : Int = 0
    
    private var auditBooking = [AuditActivityBookingDetaiModel]()
    
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
        else
                if segue.identifier == "GoBackToAuditDetail" {
                    
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
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: ScreenList as [AnyObject] , initialSelection: 1, doneBlock: {
            picker, value, index in
            
            if(value == 0)
            {
                self.performSegueWithIdentifier("GoBackToAuditDetail", sender: nil)
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
    
    @IBAction func ButtonBackClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoBackToAuditDetail", sender: nil)
    }
    
    @IBAction func ButonHomeClicked(sender: AnyObject) {
         self.performSegueWithIdentifier("GoBackToAuditActivity", sender: nil)
    }

}
