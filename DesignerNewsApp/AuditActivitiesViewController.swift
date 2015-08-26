//
//  AuditActivitiesViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Alamofire

class AuditActivitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //@IBOutlet weak var AuditorAvatar: UIImageView!
    
    private var auditRequest = [AuditRequestModel]()
    
    private var auditRequestStatus = [AuditRequestStatusModel]()

    private let reuseIdentifier = "RequestCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var imagePending = UIImage(named: "pending") as UIImage?
    private var imageWaiting = UIImage(named: "waiting") as UIImage?
    private var imageDecline = UIImage(named: "decline") as UIImage?
    
    private var imageReview = UIImage(named: "review") as UIImage?
    private var imageOngoing = UIImage(named: "ongoing") as UIImage?
    private var imageApproved = UIImage(named: "approved") as UIImage?
    private var imageStartAudit = UIImage(named: "play") as UIImage?
    private var imageComplete = UIImage(named: "complete") as UIImage?
    private var imageRework = UIImage(named: "redo") as UIImage?
    private var imageAbandonded = UIImage(named: "abandond") as UIImage?

    
    var userProfile = LoginModel()
    
    let imageCache = NSCache()
    
    var originalCenter: CGPoint!
    
    var objectStartAudit = AuditRequestStartAuditModel()
    
    
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        originalCenter = view.center

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
    }
    
    func initData(){
        
        view.showLoading()
        
        WebApiService.getAuditRequestStatusList(LocalStore.accessToken()!){ objectReturn in
            
            self.auditRequestStatus = objectReturn
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let filter = AuditRequestFilter()
                
                //accepted
                filter.Status = "3"
                
                filter.Sort = "SiteName-asc"
                
                WebApiService.getAuditRequestList(LocalStore.accessToken()!, filter : filter) { objectReturn in

                    self.auditRequest = objectReturn
                    
                    self.collectionView?.reloadData()
                    
                    self.view.hideLoading()

                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)! as! AuditRequestCollectionViewCell
        //cell.backgroundColor = UIColor.lightGrayColor()
        cell.tag = indexPath.row
        if (auditRequest[indexPath.row].AuditRequestStatusId == 3 && auditRequest[indexPath.row].AuditActivityStatusId == 0)
        {
            self.CallStartAudit(indexPath.row)
        }
        else if (auditRequest[indexPath.row].AuditRequestStatusId == 3 && (auditRequest[indexPath.row].AuditActivityStatusId == 2 || auditRequest[indexPath.row].AuditActivityStatusId == 3 || auditRequest[indexPath.row].AuditActivityStatusId == 4))
        {
            LocalStore.setAuditActivityUrlId(auditRequest[indexPath.row].AuditActivityUrlId)
                
            self.performSegueWithIdentifier("GoToAuditDetail", sender: nil)

        }
    }

    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return auditRequest.count
    }
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AuditRequestCollectionViewCell
        
        cell.ButtonStatus.removeTarget(self, action: nil, forControlEvents: .TouchUpInside)
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.AuditName.text = auditRequest[indexPath.row].SiteName
        
        if auditRequest[indexPath.row].Address.length > 0 {
            cell.AuditAddress.text = auditRequest[indexPath.row].Address + ", " + auditRequest[indexPath.row].Suburb + ", " + auditRequest[indexPath.row].StateName
        }
        else
        {
            cell.AuditAddress.text = auditRequest[indexPath.row].Suburb + ", " + auditRequest[indexPath.row].StateName
        }

        cell.AuditStartDate.text = auditRequest[indexPath.row].RequestFromDateDisplay
        cell.AuditFinishDate.text = auditRequest[indexPath.row].RequestToDateDisplay
        cell.QuestionSet.text = auditRequest[indexPath.row].QuestionSetName
        

        
        //Pending
        if auditRequest[indexPath.row].AuditRequestStatusId == 1 {
            cell.ButtonStatus.setImage(imagePending, forState: .Normal)
            cell.ButtonStatus.userInteractionEnabled = false
            cell.Status.text =  "Pending"
        }
        else
            //Waiting
            if auditRequest[indexPath.row].AuditRequestStatusId == 2 {
                cell.ButtonStatus.userInteractionEnabled = false
                cell.Status.text =  "Waiting"
            }
            else
                //Decline
                if auditRequest[indexPath.row].AuditRequestStatusId == 4 {
                    cell.ButtonStatus.setImage(imageDecline, forState: .Normal)
                    cell.ButtonStatus.userInteractionEnabled = false
                    cell.Status.text =  "Decline"
                }
                else
                    //Approved
                    if auditRequest[indexPath.row].AuditRequestStatusId == 3 {
                        //Start Audit
                        if auditRequest[indexPath.row].AuditActivityStatusId == 0 {
                            cell.ButtonStatus.setImage(imageStartAudit, forState: .Normal)
                            cell.Status.text =  "Start Audit"
                            cell.ButtonStatus.tag = indexPath.row
                            //cell.ButtonStatus.addTarget(self, action: "StartAuditButtonClicked:", forControlEvents: .TouchUpInside)
                        }
                        else
                        //Reviewing
                        if auditRequest[indexPath.row].AuditActivityStatusId == 1 {
                            cell.ButtonStatus.setImage(imageReview, forState: .Normal)
                            cell.Status.text =  "Reviewing"
                        }
                        else // Ongoing
                            if auditRequest[indexPath.row].AuditActivityStatusId == 2 {
                                cell.ButtonStatus.setImage(imageOngoing, forState: .Normal)
                                cell.ButtonStatus.tag = indexPath.row
                                //cell.ButtonStatus.addTarget(self, action: "yourButtonClicked:", forControlEvents: .TouchUpInside)
                                cell.Status.text =  "Ongoing"
                            }
                            else // Completed
                                if auditRequest[indexPath.row].AuditActivityStatusId == 3 {
                                    cell.ButtonStatus.setImage(imageComplete, forState: .Normal)
                                    cell.ButtonStatus.tag = indexPath.row
                                    //cell.ButtonStatus.addTarget(self, action: "yourButtonClicked:", forControlEvents: .TouchUpInside)
                                    cell.Status.text =  "Completed"
                                }
                                else // Rework
                                    if auditRequest[indexPath.row].AuditActivityStatusId == 4 {
                                        cell.ButtonStatus.setImage(imageRework, forState: .Normal)
                                        cell.ButtonStatus.tag = indexPath.row
                                        //cell.ButtonStatus.addTarget(self, action: "yourButtonClicked:", forControlEvents: .TouchUpInside)
                                        cell.Status.text =  "Rework"
                                    }
                                    else // Approved
                                        if auditRequest[indexPath.row].AuditActivityStatusId == 5 {
                                            cell.ButtonStatus.setImage(imageApproved, forState: .Normal)
                                            cell.Status.text =  "Approved"
                                        }
                                        else //
                                            if auditRequest[indexPath.row].AuditActivityStatusId == 6 {
                                                cell.ButtonStatus.setImage(imageAbandonded, forState: .Normal)
                                                cell.Status.text =  "Abandoned"
                                            }

                        }

        // Configure the cell
        return cell
    }
    
    func CallStartAudit(index : Int){
        

        var refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure want to start audit?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Yes logic here")
            
            self.view.showLoading()
            
            WebApiService.postAuditRequestStartAudit(LocalStore.accessToken()!, AuditRequestUrlId : self.auditRequest[index].UrlId) { objectReturn in
                
                if let temp = objectReturn {
                    
                    self.objectStartAudit = temp
                    
                    LocalStore.setAuditActivityUrlId(self.objectStartAudit.AuditActivityUrlId)
                    
                    self.performSegueWithIdentifier("GoToAuditDetail", sender: nil)
                    
                    self.view.hideLoading()
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in
            //println("Handle Cancel Logic here")
        }))
        
        refreshAlert.view.tintColor = UIColor.blackColor()
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)

    }
    
    //display Header of Colllection View
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        
            var reusableView: UICollectionReusableView = UICollectionReusableView()
        
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AuditRequestHeaderView", forIndexPath: indexPath) as! AuditRequestHeaderView

                headerView.lbl_name.text = self.userProfile.Name
                headerView.lbl_email.text = self.userProfile.EmailAddress
                headerView.lbl_phone.text = self.userProfile.Phone
                headerView.lbl_mobile.text = self.userProfile.Mobile
                headerView.lbl_companyName.text = self.userProfile.AuditorCompanyName
                headerView.lbl_companyAddress.text = self.userProfile.AuditorCompanyAddress + ", " + self.userProfile.AuditorCompanySuburb + ", " + self.userProfile.AuditorCompanyPostcode + ", " + self.userProfile.AuditorCompanyStateName
                
                
                if(self.userProfile.PhotoId != 0 ) {
                    
                    var stringURL : String = LocalStore.accessDomain()!

                    stringURL += "/Api/GetFileDocument/?fileId=" + self.userProfile.PhotoId.description
                
                    Alamofire.request(.GET, stringURL).response() {
                        (_, _, data, _) in
                        let image = UIImage(data: data! as! NSData)
                        headerView.AuditorAvatar.image  = image
                        headerView.AuditorAvatar.layer.cornerRadius = headerView.AuditorAvatar.frame.size.width / 2;
                        headerView.AuditorAvatar.clipsToBounds = true;
                    }
                }
                
                //println("Init Header View \(self.userProfile.AuditorCompanyName)")
                
                reusableView =  headerView
            default:
                //4
                fatalError("Unexpected element kind")
            }
        
        return reusableView
    }
    
    func GetStatusNameById(id : Int?, arrayObject : [AuditRequestStatusModel]) -> AuditRequestStatusModel {
        
        let temp = AuditRequestStatusModel()
        for obj in arrayObject
        {
            if obj.Id == id {
                return obj
            }
        }
        
        return temp
    }
    
    @IBAction func MenuButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("GoToMenu", sender: sender)
    }
    
    
    func animateMenuButton() {
        if let button = navigationItem.leftBarButtonItem?.customView as? MenuControl {
            button.menuAnimation()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToMenu" {
            let menuViewController = segue.destinationViewController as! MenuViewController
            menuViewController.delegate = self
            menuViewController.userProfile = self.userProfile
        }
    }

}

extension  AuditActivitiesViewController : MenuViewControllerDelegate {
    
    func menuViewControllerDidSelectCloseMenu(controller: MenuViewController) {
        animateMenuButton()
    }
    
    func menuViewControllerDidSelectActivitiesMenu(controller: MenuViewController) {
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
    }
    
    func menuViewControllerDidSelectLogoutMenu(controller: MenuViewController) {
        
        LocalStore.setAuditActivityUrlId("")
        
        LocalStore.setToken("")
        
        performSegueWithIdentifier("GoToLogin", sender: nil)
    }
    
    func menuViewControllerDidSelectChangeDomainMenu(controller: MenuViewController) {
        
        performSegueWithIdentifier("GoToChangeDomain", sender: nil)
    }
    
}



