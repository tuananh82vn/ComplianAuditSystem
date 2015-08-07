//
//  QuestionSetViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class QuestionSetViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate {


    @IBOutlet weak var QuestionView: AKPickerView!
    
    let titles = ["Tokyo", "Kanagawa", "Osaka", "Aichi", "Saitama", "Chiba", "Hyogo", "Hokkaido", "Fukuoka", "Shizuoka"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.QuestionView.delegate = self
        self.QuestionView.dataSource = self
        
        self.QuestionView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.QuestionView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.QuestionView.pickerViewStyle = .Wheel
        self.QuestionView.maskDisabled = false
        self.QuestionView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
   	func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.titles.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.titles[item]
    }
    
    func pickerView(pickerView: AKPickerView, imageForItem item: Int) -> UIImage {
        return UIImage(named: self.titles[item])!
    }
    
    // MARK: - AKPickerViewDelegate
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        println("Your favorite city is \(self.titles[item])")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // println("\(scrollView.contentOffset.x)")
    }

}
