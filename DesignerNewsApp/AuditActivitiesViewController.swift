//
//  AuditActivitiesViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditActivitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    //@IBOutlet weak var AuditorAvatar: UIImageView!
    
    private var auditRequest = [AuditRequestModel]()
    
    private var auditRequestStatus = [AuditRequestStatusModel]()

    private let reuseIdentifier = "RequestCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageReview = UIImage(named: "review") as UIImage?
    private var imageOngoing = UIImage(named: "pause") as UIImage?
    private var imageApproved = UIImage(named: "approved") as UIImage?
    private var imagePlay = UIImage(named: "play") as UIImage?
    private var imageComplete = UIImage(named: "complete") as UIImage?
    private var imageRework = UIImage(named: "redo") as UIImage?
    private var imageAbandonded = UIImage(named: "abandond") as UIImage?
    
    private var selectedAuditRequestURL :String = ""
    
    
    var originalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        initData()
    }
    
    func initData(){
        
        view.showLoading()
        
        WebApiService.getAuditRequestStatusList(LocalStore.accessToken()!){ objectReturn in
            
            self.auditRequestStatus = objectReturn
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let filter = AuditRequestFilter()
                
                WebApiService.getAuditRequestList(LocalStore.accessToken()!, filter : filter) { objectReturn in
                    
                    self.view.hideLoading()
                    
                    self.auditRequest = objectReturn
                    
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.AuditName.text = auditRequest[indexPath.row].SiteName
        cell.AuditAddress.text = auditRequest[indexPath.row].Address + "," + auditRequest[indexPath.row].Suburb + "," + auditRequest[indexPath.row].StateName
        cell.AuditorUser.text = auditRequest[indexPath.row].AuditorName
        cell.AuditCompanyName.text = auditRequest[indexPath.row].AuditCompanyName
        cell.AuditStartDate.text = auditRequest[indexPath.row].RequestFromDateDisplay
        cell.AuditFinishDate.text = auditRequest[indexPath.row].RequestToDateDisplay
        cell.QuestionSet.text = auditRequest[indexPath.row].QuestionSetName
        let AuditRequestStatus = self.GetStatusNameById(auditRequest[indexPath.row].AuditRequestStatusId, arrayObject : self.auditRequestStatus)
        cell.Status.text =  AuditRequestStatus.Name
        
        var Color = UIColor.clearColor()
        if AuditRequestStatus.Color == "blue"{
            Color = UIColor.blueColor()
        }
        else
            if AuditRequestStatus.Color == "yellow"{
                Color = UIColor.yellowColor()
        }
            else
                if AuditRequestStatus.Color == "green"{
                    Color = UIColor.greenColor()
        }
                else
                    if AuditRequestStatus.Color == "red"{
                        Color = UIColor.redColor()
        }
        
        cell.Status.textColor = Color

        
        //imageReview
        if auditRequest[indexPath.row].AuditActivityStatusId == 1 {
            cell.ButtonStatus.setImage(imageReview, forState: .Normal)
            cell.ButtonStatus.userInteractionEnabled = false
        }
        else // imageOngoing
            if auditRequest[indexPath.row].AuditActivityStatusId == 2 {
                cell.ButtonStatus.setImage(imageOngoing, forState: .Normal)
                cell.ButtonStatus.tag = indexPath.row
                cell.ButtonStatus.addTarget(self, action: "yourButtonClicked:", forControlEvents: .TouchUpInside)
            }
            else // imageComplete
                if auditRequest[indexPath.row].AuditActivityStatusId == 3 {
                    cell.ButtonStatus.setImage(imageComplete, forState: .Normal)
                    cell.ButtonStatus.userInteractionEnabled = false
                }
                else // imageRework
                    if auditRequest[indexPath.row].AuditActivityStatusId == 4 {
                        cell.ButtonStatus.setImage(imageRework, forState: .Normal)
                        cell.ButtonStatus.tag = indexPath.row
                        cell.ButtonStatus.addTarget(self, action: "yourButtonClicked:", forControlEvents: .TouchUpInside)
                    }
                    else // imageApproved
                        if auditRequest[indexPath.row].AuditActivityStatusId == 5 {
                            cell.ButtonStatus.setImage(imageApproved, forState: .Normal)
                            cell.ButtonStatus.userInteractionEnabled = false
                        }
                        else // imageAbandonded
                            if auditRequest[indexPath.row].AuditActivityStatusId == 6 {
                                cell.ButtonStatus.setImage(imageAbandonded, forState: .Normal)
                                cell.ButtonStatus.userInteractionEnabled = false
                            }
                            else //
                                    if auditRequest[indexPath.row].AuditActivityStatusId == nil {
                                            cell.ButtonStatus.enabled = false
                                            cell.ButtonStatus.userInteractionEnabled = false
                                }
        

        // Configure the cell
        return cell
    }
    
    func yourButtonClicked(sender : UIButton)
    {
        self.selectedAuditRequestURL = auditRequest[sender.tag].AuditActivityUrlId

        self.performSegueWithIdentifier("GoToAuditDetail", sender: sender)

    }
    
    //display Header of Colllection View
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AuditRequestHeaderView", forIndexPath: indexPath) as! AuditRequestHeaderView
                //headerView.label.text = searches[indexPath.section].searchTerm
                headerView.AuditorAvatar.layer.cornerRadius = headerView.AuditorAvatar.frame.size.width / 2;
                headerView.AuditorAvatar.clipsToBounds = true;
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToAuditDetail" {
            //println("prepare Go to Audit Detail")
            let auditDetailViewController = segue.destinationViewController as! AuditDetailViewController
            auditDetailViewController.AuditActivityUrlId = self.selectedAuditRequestURL
        }
    }

}



