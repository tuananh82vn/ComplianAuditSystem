//
//  MenuViewController.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import Spring

protocol MenuViewControllerDelegate : class {
    
    func menuViewControllerDidSelectCloseMenu(controller:MenuViewController)
    
    func menuViewControllerDidSelectActivitiesMenu(controller:MenuViewController)
    
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var dialogView: SpringView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    
    var userProfile = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var firstTime = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if firstTime {
            dialogView.animate()
            firstTime = false
        }
    }
    
    // MARK: Buttons
    @IBAction func topButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func ActivitiesButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.menuViewControllerDidSelectActivitiesMenu(self)
        closeButtonPressed(self)
    }
    
    @IBAction func creditsButtonPressed(sender: AnyObject) {
        animateView()
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        delegate?.menuViewControllerDidSelectCloseMenu(self)
        dialogView.animation = "fall"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    // MARK: Misc

    func animateView() {
        dialogView.animation = "pop"
        dialogView.animate()
    }

}