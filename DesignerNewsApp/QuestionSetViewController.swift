//
//  QuestionSetViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class QuestionSetViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView1: UITableView!

    @IBOutlet weak var QuestionView: AKPickerView!
    
    @IBOutlet weak var viewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint : NSLayoutConstraint!
    
    var questionSet = [AuditActivityQuestionSetModel]()
    var selectedIndex : Int = 0
    var height: Int = 0

    override func viewDidLoad() {
        
        println("viewDidLoad")
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

        InitData()
        
        self.QuestionView.delegate = self
        self.QuestionView.dataSource = self
        
        self.QuestionView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.QuestionView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.QuestionView.pickerViewStyle = .Wheel
        self.QuestionView.maskDisabled = false
        self.QuestionView.reloadData()
        
        
        self.viewHeightConstraint.constant = CGFloat(0)
        self.view.layoutIfNeeded()

        
        self.scrollView.contentSize = CGSizeMake(tableView1.frame.width-1, CGFloat(0))
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewWidthConstraint.constant = self.QuestionView.frame.width
        self.view.layoutIfNeeded()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func rotated()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {

        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {

        }

        self.viewWidthConstraint.constant = self.QuestionView.frame.width
        self.view.layoutIfNeeded()
        
    }
    
    func InitData(){
        
            view.showLoading()
            
            WebApiService.getAuditActivityQuestionSetList(LocalStore.accessToken()!, AuditActivityUrlId: LocalStore.accessAuditActivityUrlId()!) { objectReturn in
                
                if let temp = objectReturn {

                    self.questionSet = temp
                      dispatch_async(dispatch_get_main_queue()) {
                        for item in self.questionSet {
                    
                            var QuestionRespond = AuditActivityQuestionSetQuestionResponseModel()
                        
                            QuestionRespond.AuditActivityQuestionSetId = item.AuditActivityQuestionSetId

                            dispatch_async(dispatch_get_main_queue()) {
                                
                                WebApiService.getAuditActivityQuestionSetQuestionResponseList(LocalStore.accessToken()!, QuestionRespond: QuestionRespond ) { objectReturn in
                        
                                    if let temp = objectReturn {
                                        item.QuestionBySectionList = temp.QuestionBySectionList
                                    }
                                }
                            }
                        }
                    
                    self.view.hideLoading()
                    
                    self.QuestionView.reloadData()
                    
                    self.tableView1.reloadData()
                    }
                    
                }
            }
    }
    
    
   	func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.questionSet.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.questionSet[item].AuditActivityQuestionSetName
    }
    
    func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return UIImage(named: self.questionSet[item].AuditActivityQuestionSetName)!
    }
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        self.selectedIndex = item
        
        var numberOfSection = self.questionSet[selectedIndex].QuestionBySectionList.count
        var numberOfRow = 0
        for section in self.questionSet[selectedIndex].QuestionBySectionList {
            numberOfRow += section.QuestionResponseModelList.count
        }
        
        self.height = ((numberOfSection * 51) + (numberOfRow * 44))
        
        self.viewHeightConstraint.constant = CGFloat(self.height)
        
        self.view.layoutIfNeeded()
        
        self.scrollView.contentSize = CGSizeMake(tableView1.frame.width, CGFloat(self.height + 100))
        
        self.tableView1.reloadData()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(questionSet.count > 0 )
        {
            if (questionSet[selectedIndex].QuestionBySectionList.count > 0){
                if (questionSet[selectedIndex].QuestionBySectionList[section].QuestionResponseModelList.count > 0) {
                    
                    return questionSet[selectedIndex].QuestionBySectionList[section].QuestionResponseModelList.count
                    
                }
                else
                {
                    return 0
                }
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("DetailCell") as! QuestionSetViewCell
        
        cell1.lbl_Number.text =   self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].SerialNumber.description
        cell1.lbl_Question.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].Name
        cell1.lbl_Response.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].AuditResponse
        cell1.lbl_Priority.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].Priority
        cell1.lbl_Category.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].ResponseCategoryName
        
        
        
//        if indexPath.row % 2 != 0 {
//            cell1.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
//        } else {
//            cell1.backgroundColor = UIColor.whiteColor()
//        }
        
        return cell1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if (questionSet.count > 0)  {
            if(questionSet[selectedIndex].QuestionBySectionList.count > 0){
                return questionSet[selectedIndex].QuestionBySectionList.count
            }
            else{
                return 0
            }
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {

        var view = UIView()
        
        var label = UILabel()
        
        label.text = questionSet[selectedIndex].QuestionBySectionList[section].SectionName
        label.textColor = UIColor.whiteColor()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)

        let views = ["label": label,"view": view]
        view.addSubview(label)
        var horizontallayoutContraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label]-10-|", options: .AlignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontallayoutContraints)
        
        var verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
        view.addConstraint(verticalLayoutContraint)
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
