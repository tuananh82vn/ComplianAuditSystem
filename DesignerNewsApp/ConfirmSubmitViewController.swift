//
//  ConfirmSubmitViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 17/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class ConfirmSubmitViewController: UIViewController , UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var view1: UIView!
    
    var AuditOutcomeList = [AuditOutcomeModel]()
    
    @IBOutlet weak var bt_Select: UIButton!
    
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    struct properties {
        static let moods = [
            ["title" : "the best", "color" : "#8647b7"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "really good", "color": "#4870b7"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "not so great", "color" : "#c6802e"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "the worst", "color" : "#b05050"]
        ]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitData()
        
        createPicker()

        // Do any additional setup after loading the view.
    }

    func InitData(){
        view.showLoading()
        
        WebApiService.getAuditOutcomeList(LocalStore.accessToken()!) { objectReturn in
            
            if let temp = objectReturn {
                
                self.AuditOutcomeList = temp
                
                self.view.hideLoading()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonSelectClicked(sender: AnyObject) {
        picker.hidden ? openPicker() : closePicker()
    }
    
    @IBAction func ButtonCancelClicked(sender: AnyObject) {
    }

    @IBAction func ButtonSubmitClicked(sender: AnyObject) {
    }
    
    func createPicker()
    {
        
        let picker_height = 21 + self.properties.moods.count * 43
        picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: picker_height)
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        picker.layer.zPosition = 9000
        
        var offset = 21
        
        for (index, feeling) in enumerate(properties.moods)
        {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: offset, width: 178  , height: 43)
            button.setTitleColor(UIColor(rgba: feeling["color"]!), forState: .Normal)
            button.setTitle(feeling["title"], forState: .Normal)
            button.tag = index
            button.addTarget(self, action: "ButtonEditClicked:", forControlEvents: .TouchUpInside)
            picker.addSubview(button)
            
            offset += 44
        }
        
        view1.addSubview(picker)
    }
    
    func ButtonEditClicked(sender : UIButton)
    {
        println("button \(sender.tag) clicked")
        let temp = properties.moods[sender.tag]["title"]
        
        self.bt_Select.setTitle(temp, forState: .Normal)
        closePicker()
    }
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: 291)
                self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3,
            animations: {
                self.picker.frame = CGRect(x: self.bt_Select.frame.origin.x, y: self.bt_Select.frame.origin.y + self.bt_Select.frame.height , width: self.bt_Select.frame.width, height: 291)
                self.picker.alpha = 0
            },
            completion: { finished in
                self.picker.hidden = true
            }
        )
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
}
