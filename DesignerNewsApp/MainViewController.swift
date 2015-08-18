//
//  MainViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var userProfile = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToMenu" {
            let menuViewController = segue.destinationViewController as! MenuViewController
            menuViewController.delegate = self
            menuViewController.userProfile = self.userProfile
        }
        else
            if segue.identifier == "ActivitiesSegue" {
                let auditViewController = segue.destinationViewController as! AuditActivitiesViewController
                auditViewController.userProfile = self.userProfile
        }
        
    }
    
    @IBAction func MenuButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("GoToMenu", sender: sender)
    }

    
    func animateMenuButton() {
        if let button = navigationItem.leftBarButtonItem?.customView as? MenuControl {
            button.menuAnimation()
        }
    }

}

extension  MainViewController : MenuViewControllerDelegate {

    func menuViewControllerDidSelectCloseMenu(controller: MenuViewController) {
        animateMenuButton()
    }
    
    func menuViewControllerDidSelectActivitiesMenu(controller: MenuViewController) {
        performSegueWithIdentifier("ActivitiesSegue", sender: nil)
    }
    func menuViewControllerDidSelectLogoutMenu(controller: MenuViewController) {
        
        LocalStore.setAuditActivityUrlId("")
        
        LocalStore.setToken("")
        
        performSegueWithIdentifier("GoToLogin", sender: nil)
    }
}
