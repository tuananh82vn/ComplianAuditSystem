//
//  QuestionSetViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Charts


class QuestionSetViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var pieChartMadatory: PieChartView!
    @IBOutlet weak var pieChartAll: PieChartView!
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView1: UITableView!

    @IBOutlet weak var QuestionView: AKPickerView!
    
    @IBOutlet weak var viewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var viewWidthConstraint : NSLayoutConstraint!
    
    var questionSet = [AuditActivityQuestionSetModel]()
    var selectedIndex : Int = 0
    var height: Int = 0
    var selectQuestionReponseId : Int = 0
    
    var filterQuestion = AuditActivityQuestionSetQuestionResponseModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        InitData()

        self.QuestionView.delegate = self
        self.QuestionView.dataSource = self
        
        self.QuestionView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.QuestionView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.QuestionView.pickerViewStyle = .Wheel
        self.QuestionView.maskDisabled = false
        self.QuestionView.reloadData()
        
        
        self.viewHeightConstraint.constant = CGFloat(0)

        self.scrollView.contentSize = CGSizeMake(tableView1.frame.width-1, CGFloat(0))
        
        self.view.layoutIfNeeded()

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refesh:",name:"refeshQuestion", object: nil)
    }
    
    func refesh(notification: NSNotification){
        
        self.selectedIndex = notification.userInfo!["selectedIndex"] as! Int
        
        self.view.showLoading()
        
        LoadQuestionData()
        
        //Reload chart view
        var questionText1 = [String]()
        var questionNumber1 = [Double]()
        var questionColors1 = [UIColor]()
        
        for chart in self.questionSet[selectedIndex].QuestionChart.MadatoryQuestionChartList {
            questionText1.append(chart.QuestionStatusName)
            questionNumber1.append(Double(chart.QuestionCount))
            questionColors1.append(UIColor(hex: chart.ColorCode))
        }
        
        setChart(self.pieChartMadatory,chartName : "Mandatory Questions",dataPoints : questionText1, values: questionNumber1 , colors : questionColors1)
        
        var questionText2 = [String]()
        var questionNumber2 = [Double]()
        var questionColors2 = [UIColor]()
        
        for chart in self.questionSet[selectedIndex].QuestionChart.AllQuestionChartList {
            questionText2.append(chart.QuestionStatusName)
            questionNumber2.append(Double(chart.QuestionCount))
            questionColors2.append(UIColor(hex: chart.ColorCode))
        }
        
        setChart(self.pieChartAll,chartName : "All Questions",dataPoints : questionText2, values: questionNumber2 , colors : questionColors2)
        
        //Reload table view
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

    func setChart(chart : PieChartView, chartName : String , dataPoints: [String], values: [Double], colors :[UIColor]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: chartName)
        
        pieChartDataSet.colors = colors
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        chart.data = pieChartData
        chart.drawHoleEnabled = false
        //chart.usePercentValuesEnabled = true
        chart.drawSliceTextEnabled = false
        chart.descriptionText = ""
        chart.setNeedsDisplay()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewWidthConstraint.constant = self.QuestionView.frame.width
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //handle when device rotate
    func rotated(){
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
                    
                    self.LoadQuestionData()
                    
                    self.QuestionView.reloadData()
                }
            }
    }
    
    func LoadQuestionData(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            var index = 0
            
            for item in self.questionSet {

                self.filterQuestion.AuditActivityQuestionSetId = item.AuditActivityQuestionSetId
                
                //load question set by Id
                WebApiService.getAuditActivityQuestionSetQuestionResponseList(LocalStore.accessToken()!, QuestionRespond: self.filterQuestion ) { objectReturn in
                    
                    if let temp1 = objectReturn {
                        item.QuestionBySectionList = temp1.QuestionBySectionList
                        
                        
                        //load chart data By Id
                        WebApiService.getAuditActivityQuestionSetQuestionResponsePieChart(LocalStore.accessToken()!, AuditActivityQuestionSetId: self.filterQuestion.AuditActivityQuestionSetId ) { objectReturn in
                            
                            if let temp2 = objectReturn {
                                item.QuestionChart = temp2
                                
                                if(index == self.questionSet.count-1)
                                {
                                    self.view.hideLoading()
                                    self.displayById(self.selectedIndex)
                                }
                                else
                                {
                                    index++
                                }
                            }
                        }
                    }
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
    
    //AKPickerViewDelegate
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        
        self.selectedIndex = item
        self.displayById(selectedIndex)
        
    }
    
    func displayById(Index : Int)
    {
        //Reload chart view
        var questionText1 = [String]()
        var questionNumber1 = [Double]()
        var questionColors1 = [UIColor]()
        
        for chart in self.questionSet[Index].QuestionChart.MadatoryQuestionChartList {
            questionText1.append(chart.QuestionStatusName)
            questionNumber1.append(Double(chart.QuestionCount))
            questionColors1.append(UIColor(hex: chart.ColorCode))
        }
        
        setChart(self.pieChartMadatory,chartName : "Mandatory Questions",dataPoints : questionText1, values: questionNumber1 , colors : questionColors1)
        
        var questionText2 = [String]()
        var questionNumber2 = [Double]()
        var questionColors2 = [UIColor]()
        
        for chart in self.questionSet[Index].QuestionChart.AllQuestionChartList {
            questionText2.append(chart.QuestionStatusName)
            questionNumber2.append(Double(chart.QuestionCount))
            questionColors2.append(UIColor(hex: chart.ColorCode))
        }
        
        setChart(self.pieChartAll,chartName : "All Questions",dataPoints : questionText2, values: questionNumber2 , colors : questionColors2)
        
        //Reload table view
        var numberOfSection = self.questionSet[Index].QuestionBySectionList.count
        
        var numberOfRow = 0
        
        for section in self.questionSet[Index].QuestionBySectionList {
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
        
        
        //println("cellForRowAtIndexPath")
        
        var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("DetailCell") as! QuestionSetViewCell
        
        cell1.lbl_Number.text   =   "Q-" + self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].SerialNumber.description
        cell1.lbl_Question.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].Name
        cell1.lbl_Response.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].AuditResponse
        cell1.lbl_Priority.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].Priority
        cell1.lbl_Category.text = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].ResponseCategoryName
        
        
        if self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].FileId == 0 {
            cell1.bt_Download.hidden = true
        }
        else
        {
            cell1.bt_Download.hidden = false
        }
        
        if self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].AuditResponse != "" && self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].ResponseCategoryName != "" {
            cell1.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell1.tintColor = UIColor.blackColor()
        }
        else
        {
            cell1.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell1.tintColor = UIColor.whiteColor()
        }
        
        
        cell1.bt_Edit.tag = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].AuditActivityQuestionSetQuestionResponseId
        
        cell1.bt_Edit.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
        
        if self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].FileId == 0 {
            cell1.bt_Download.hidden = true
        }
        else
        {
            cell1.bt_Download.hidden = false
            
            cell1.bt_Download.tag = self.questionSet[self.selectedIndex].QuestionBySectionList[indexPath.section].QuestionResponseModelList[indexPath.row].FileId
            
            cell1.bt_Download.addTarget(self, action: "ButtonDownloadClicked:", forControlEvents: .TouchUpInside)
        }
        
        return cell1
        
    }
    
    func ButtonDownloadClicked(sender : UIButton)
    {
        
        WebApiService.getFile(sender.tag) { objectReturn in
            
            self.performSegueWithIdentifier("GoToWebviewer", sender: objectReturn)
        }
    }
    
    func ButtonEditClicked(sender : UIButton)
    {
        self.selectQuestionReponseId = sender.tag
        
        self.performSegueWithIdentifier("GoToQuestionEdit", sender: sender)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(selectedIndex >= 0){
            if (questionSet.count > 0)  {
                if(questionSet[selectedIndex].QuestionBySectionList.count > 0){
                    return questionSet[selectedIndex].QuestionBySectionList.count
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var view = UIView()
        
        var label = UILabel()
        
        label.text = "Section - " + questionSet[selectedIndex].QuestionBySectionList[section].SectionNumber.description + " " + questionSet[selectedIndex].QuestionBySectionList[section].SectionName
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToQuestionEdit" {
            let controller = segue.destinationViewController as! QuestionSetEditViewController
            controller.QuestionId = self.selectQuestionReponseId
            controller.selectedIndex = self.selectedIndex
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
            if segue.identifier == "GoToSearch" {
                    let SearchViewController = segue.destinationViewController as! QuestionSetSearchViewController
                    SearchViewController.delegate = self
        }
        

    }
    

    @IBAction func ButtonSearchClicked(sender: AnyObject) {
        performSegueWithIdentifier("GoToSearch", sender: sender)
    }
    
    @IBAction func ButtonConfirmClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("GoToSubmit", sender: sender)
    }
}

extension  QuestionSetViewController : QuestionSetSearchViewControllerDelegate {
    
    func DidSelectClose(controller: QuestionSetSearchViewController) {
        
        if(controller.filterQuestion.Priority != "0" ){
            self.filterQuestion.Priority = controller.filterQuestion.Priority
        }
        else
        {
            self.filterQuestion.Priority = ""
        }
        
        if(controller.filterQuestion.QuestionStatus != "0" ){
            self.filterQuestion.QuestionStatus = controller.filterQuestion.QuestionStatus
        }
        else
        {
            self.filterQuestion.QuestionStatus = ""
        }
        
        if(controller.filterQuestion.ResponseCategory != "0"){
            self.filterQuestion.ResponseCategory = controller.filterQuestion.ResponseCategory
        }
        else
        {
            self.filterQuestion.ResponseCategory = ""
        }
        
        self.LoadQuestionData()
        
        self.QuestionView.reloadData()
        
    }

}

