//
//  LoginViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-06.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

var keychain = Keychain()

class LoginViewController: UIViewController, UITextFieldDelegate, DragDropBehaviorDelegate {

    @IBOutlet weak var switchRememberMe: UISwitch!
    @IBOutlet weak var passwordImageView: SpringImageView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var signupButton: SpringButton!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    var originalCenter: CGPoint!

    var userProfile = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenter = view.center
        
        emailTextField.text = keychain["username"]
        passwordTextField.text = keychain["password"]
        
        if (emailTextField.text != "" &&  passwordTextField.text != ""){
            switchRememberMe.on = true
        }
        else
        {
            switchRememberMe.on = false
        }
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        //LocalStore.setDomain("http://wsandypham:8080")
        //LocalStore.setDomain("http://complianceauditsystem.softwarestaging.com.au")
        
        //keychain["domain"] = "http://complianceauditsystem.softwarestaging.com.au"

        
        if(keychain["domain"] == nil)
        {
            keychain["domain"] = "http://complianceauditsystem.softwarestaging.com.au"
        }
        if let domain = keychain["domain"]
        {
            //LocalStore.deleteDomain()
            LocalStore.setDomain(domain)
        }
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        dialogView.animate()
    }
    
    // MARK: Button
    @IBAction func signupButtonPressed(sender: AnyObject) {

        DoLogin()
    }
    
    func DoLogin(){
        
        view.showLoading()
        
        WebApiService.loginWithUsername(emailTextField.text, password: passwordTextField.text) { object in
            
            self.view.hideLoading()
            
            if let temp = object {

                if (self.switchRememberMe.on)
                {
                    keychain["username"] = self.emailTextField.text
                    keychain["password"] = self.passwordTextField.text
                }
                else
                {
                    keychain["username"] = ""
                    keychain["password"] = ""
                }
                
                self.userProfile = temp
                
                LocalStore.setToken(self.userProfile.TokenNumber)
                
                self.dialogView.animation = "zoomOut"
                self.dialogView.animate()
                self.dismissViewControllerAnimated(true, completion: nil)
                
                self.performSegueWithIdentifier("GoToActivity", sender: self)
                
            }
            else
            {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "zoomOut"
        dialogView.animate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    @IBAction func scrollViewPressed(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField {
            emailImageView.image = UIImage(named: "icon-mail-active")
            emailImageView.animate()
        }
        else {
            emailImageView.image = UIImage(named: "icon-mail")
        }
        
        if textField == passwordTextField {
            passwordImageView.image = UIImage(named: "icon-password-active")
            passwordImageView.animate()
        }
        else {
            passwordImageView.image = UIImage(named: "icon-password")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        emailImageView.image = UIImage(named: "icon-mail")
        passwordImageView.image = UIImage(named: "icon-password")
    }

    func dragDropBehavior(behavior: DragDropBehavior, viewDidDrop view: UIView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        DoLogin()
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func ButtonForgotClicked(sender: AnyObject) {
        let URL = LocalStore.accessDomain()!+"/login/forgotpassword"
        
        UIApplication.sharedApplication().openURL(NSURL(string:URL)!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToActivity" {
            let GoToActivity = segue.destinationViewController as! AuditActivitiesViewController
            GoToActivity.userProfile = self.userProfile
        }
    }
}
