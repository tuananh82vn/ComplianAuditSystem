//
//  ChangeDomainViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 24/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Spring

class ChangeDomainViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var txt_DomainName: UITextField!
    @IBOutlet weak var dialogView: SpringView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_DomainName.delegate = self
        txt_DomainName.text = keychain["domain"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animate()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        DoSave()
        txt_DomainName.resignFirstResponder()
        return true
    }

    @IBAction func ButtonCancelClicked(sender: AnyObject) {
            navigationController?.popViewControllerAnimated(true)
    }
    
    func DoSave(){
        
        view.showLoading()
        
        WebApiService.postVerify(txt_DomainName.text){ objectReturn in
            
            
            if let temp = objectReturn {
                
                if(temp.IsSuccess){
                    self.view.hideLoading()
                    keychain["domain"] = self.txt_DomainName.text
                    
                    LocalStore.setAuditActivityUrlId("")
                    LocalStore.setToken("")
                    LocalStore.setDomain(self.txt_DomainName.text)
                    
                    self.dialogView.animation = "zoomOut"
                    self.dialogView.animate()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    self.performSegueWithIdentifier("GoToLogin", sender: self)
                    
                }
            }
            else
            {
                self.view.hideLoading()
                
                var errorMessage : String = "Invalid domain name"
                
                let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                alertController.view.tintColor = UIColor.blackColor()
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        DoSave()
    }
}
