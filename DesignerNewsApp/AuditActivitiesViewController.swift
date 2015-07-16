//
//  AuditActivitiesViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditActivitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    
    private var auditRequest = [AuditRequestModel]()
    
    
    private let reuseIdentifier = "RequestCell"
    
    func initData(){
    
        
        let request = AuditRequestModel()
        
        request.AuditCompanyName = "Planet Pizza"
        request.AuditorName = "Khanh Le"
        request.QuestionSetName = "Demo 1"
        request.RequestFromDate = NSDate()
        request.RequestToDate = NSDate()
        request.Address = "Footray market"
        
        auditRequest.insert(request, atIndex: 0)
        auditRequest.insert(request, atIndex: 1)
        auditRequest.insert(request, atIndex: 2)
        auditRequest.insert(request, atIndex: 3)
        auditRequest.insert(request, atIndex: 4)
        auditRequest.insert(request, atIndex: 5)
        auditRequest.insert(request, atIndex: 6)
        auditRequest.insert(request, atIndex: 7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        
        // Do any additional setup after loading the view.
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
        
        cell.AuditCompanyName.text = auditRequest[indexPath.row].AuditCompanyName
        
        // Configure the cell
        return cell
    }


}
