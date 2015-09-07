//
//  Login2ViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Spring

var keychain = Keychain()
var ScreenList = ["Audit Detail","Booking","Audit Plan","Meeting Attendance","Question Set","Confirm Submit"]

class Login2ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tft_Password: UITextField!
    @IBOutlet weak var tft_Username: UITextField!
    
    var originalCenter: CGPoint!
    
    var userProfile = LoginModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        originalCenter = view.center
        
//        tft_Username.text = "auditorone"
//        tft_Password.text = "password"
        

        if(keychain["domain"] == nil)
        {
            keychain["domain"] = "http://complianceauditsystem.softwarestaging.com.au"
        }
        
        if let domain = keychain["domain"]
        {
            LocalStore.setDomain(domain)
        }
        
        tft_Password.delegate = self
        tft_Username.delegate = self
        
        //set no back button for Login screen
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)

        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        
        if (textField.returnKeyType == UIReturnKeyType.Next)
        {
            tft_Password.becomeFirstResponder()
        }
        
        if (textField.returnKeyType == UIReturnKeyType.Go)
        {
            DoLogin()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DoLogin(){
        
        self.view.showLoading()
        
        WebApiService.loginWithUsername(tft_Username.text, password: tft_Password.text) { object in
            
            self.view.hideLoading()
            
            if let temp = object {

                self.userProfile = temp
                
                LocalStore.setToken(self.userProfile.TokenNumber)
                
                keychain["userProfile_Name"] = self.userProfile.Name
                keychain["userProfile_Email"] = self.userProfile.EmailAddress
                keychain["userProfile_Phone"] = self.userProfile.Phone
                keychain["userProfile_Mobile"] = self.userProfile.Mobile
                keychain["userProfile_Company"] = self.userProfile.AuditorCompanyName
                keychain["userProfile_CompanyAddress"] = self.userProfile.AuditorCompanyAddress + ", " + self.userProfile.AuditorCompanySuburb + ", " + self.userProfile.AuditorCompanyPostcode + ", " + self.userProfile.AuditorCompanyStateName
                keychain["userProfile_PhotoId"] = self.userProfile.PhotoId.description
                
                
                self.performSegueWithIdentifier("GoToActivity", sender: self)
                
            }
            else
            {
                JSSAlertView().danger(
                    self,
                    title: "Error",
                    text: "Incorrect username or password"
                )
            }
        }
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
//    }
    
//    func keyboardWillShowNotification(notification: NSNotification) {
//        self.navigationController?.navigationBarHidden = false
//    }
//    
//    func keyboardWillHideNotification(notification: NSNotification) {
//        self.navigationController?.navigationBarHidden = false
//    }
    
    @IBAction func ButonLoginClicked(sender: AnyObject) {
        //Check Internet
        WebApiService.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                
                if (internet)
                {
                    self.DoLogin()
                }
                else
                {
                    var customIcon = UIImage(named: "no-internet")
                    var alertview = JSSAlertView().show(self, title: "Warning", text: "No connections are available ", buttonText: "Try later", color: UIColorFromHex(0xe74c3c, alpha: 1), iconImage: customIcon)
                    alertview.setTextTheme(.Light)
                }
        })

    }

}
