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

class Login2ViewController: UIViewController {

    @IBOutlet weak var Switch_RemmeberMe: UISwitch!
    @IBOutlet weak var tft_Password: UITextField!
    @IBOutlet weak var tft_Username: UITextField!
    
    var originalCenter: CGPoint!
    
    var userProfile = LoginModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        tft_Username.text = keychain["username"]
        tft_Password.text = keychain["password"]
        
        if (tft_Username.text != "" &&  tft_Password.text != ""){
            Switch_RemmeberMe.on = true
        }
        else
        {
            Switch_RemmeberMe.on = false
        }
        
        if(keychain["domain"] == nil)
        {
            keychain["domain"] = "http://complianceauditsystem.softwarestaging.com.au"
        }
        if let domain = keychain["domain"]
        {
            LocalStore.setDomain(domain)
        }
        
        //set no back button for Login screen
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        // Do any additional setup after loading the view.
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
                
                if (self.Switch_RemmeberMe.on)
                {
                    keychain["username"] = self.tft_Username.text
                    keychain["password"] = self.tft_Password.text
                }
                else
                {
                    keychain["username"] = ""
                    keychain["password"] = ""
                }
                
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
//                self.dialogView.animation = "shake"
//                self.dialogView.animate()
            }
        }
    }

    
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
