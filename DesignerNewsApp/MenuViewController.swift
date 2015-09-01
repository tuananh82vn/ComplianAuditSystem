

import UIKit
import Spring

protocol MenuViewControllerDelegate : class {
    
    func menuViewControllerDidSelectCloseMenu(controller:MenuViewController)
    
    func menuViewControllerDidSelectActivitiesMenu(controller:MenuViewController)
    
    func menuViewControllerDidSelectLogoutMenu(controller:MenuViewController)
    
   // func menuViewControllerDidSelectChangeDomainMenu(controller:MenuViewController)
 
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
    
    
    @IBAction func ActivitiesButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.menuViewControllerDidSelectActivitiesMenu(self)
        closeButtonPressed(self)
    }

//    @IBAction func ChangeDomainButtonPressed(sender: AnyObject) {
//        animateView()
//        delegate?.menuViewControllerDidSelectChangeDomainMenu(self)
//        closeButtonPressed(self)
//    }
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        animateView()
        delegate?.menuViewControllerDidSelectLogoutMenu(self)
        closeButtonPressed(self)
    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        delegate?.menuViewControllerDidSelectCloseMenu(self)
        dialogView.animation = "morph"
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