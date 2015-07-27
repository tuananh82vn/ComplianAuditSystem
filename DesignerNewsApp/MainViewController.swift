//
//  MainViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
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
}
