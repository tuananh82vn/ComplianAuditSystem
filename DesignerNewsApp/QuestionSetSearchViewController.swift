

import UIKit
import Spring

protocol QuestionSetSearchViewControllerDelegate : class {
    
    func DidSelectClose(controller:MenuViewController)
    
}

class QuestionSetSearchViewController: UIViewController {
    
    weak var delegate: QuestionSetSearchViewControllerDelegate?
    
    @IBOutlet weak var dialogView: SpringView!


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
    
    
    @IBAction func SearchButtonPressed(sender: AnyObject) {
        animateView()
        //delegate?.menuViewControllerDidSelectActivitiesMenu(self)
        closeButtonPressed(self)
    }

    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        //delegate?.menuViewControllerDidSelectCloseMenu(self)
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