

import UIKit
import Spring
import CoreActionSheetPicker

protocol QuestionSetSearchViewControllerDelegate : class {
    
    func DidSelectClose(controller:QuestionSetSearchViewController)
    
}

class QuestionSetSearchViewController: UIViewController {
    
    
    @IBOutlet weak var bt_Reponse: UIButton!
    @IBOutlet weak var bt_Status: UIButton!
    @IBOutlet weak var bt_priority: UIButton!
    
    weak var delegate: QuestionSetSearchViewControllerDelegate?
    
    @IBOutlet weak var dialogView: SpringView!

    var priorityList = ["All","Critical","High","Medium","Low"]
    var StatusList = ["All","Completed","Uncompleted"]
    var ReponseList = [String]()

    var firstTime = true
    
    var selectPriority : Int = 0
    var selectStatus : Int = 0
    var selectResponse : Int = 0
    
    var reponseCategory = [ResponseCategoryModel]()
    
    var filterQuestion = AuditActivityQuestionSetQuestionResponseModel()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        initData()
    }

    func initData(){
    
        view.showLoading()
        
        self.ReponseList.insert("All", atIndex: 0)
        
        WebApiService.getResponseCategoryList(LocalStore.accessToken()!) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                self.reponseCategory = temp
                var index = 1;
                
        
                for object in self.reponseCategory {
                    
                    self.ReponseList.insert(object.Name, atIndex: index)
                    index++;
                    
                }
                
            }
        }}
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if firstTime {
            dialogView.animation = "zoomIn"
            dialogView.animate()
            firstTime = false
        }
    }
    
    @IBAction func ButtonStatusSelected(sender: AnyObject) {
        
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: StatusList as [AnyObject] , initialSelection: self.selectStatus, doneBlock: {
            picker, value, index in
            
            self.bt_Status.setTitle((index as! String), forState: .Normal)
            self.filterQuestion.QuestionStatus  = value.description
            
            self.selectStatus = value
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func ButtonReponseSelected(sender: AnyObject) {
        
        ActionSheetStringPicker.showPickerWithTitle("Select", rows: ReponseList as [AnyObject] , initialSelection: self.selectResponse, doneBlock: {
            picker, value, index in
            
            self.bt_Reponse.setTitle((index as! String), forState: .Normal)
            self.filterQuestion.ResponseCategory  = value.description
            self.selectResponse = value
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    @IBAction func ButtonPrioritySelected(sender: AnyObject) {
        
            ActionSheetStringPicker.showPickerWithTitle("Select", rows: priorityList as [AnyObject] , initialSelection: self.selectPriority, doneBlock: {
            picker, value, index in
        
            self.bt_priority.setTitle((index as! String), forState: .Normal)
            self.filterQuestion.Priority  = value.description
            self.selectPriority = value

            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func SearchButtonPressed(sender: AnyObject) {
        delegate?.DidSelectClose(self)
        closeButtonPressed(self)
    }

    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        dialogView.animation = "zoomOut"
        dialogView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    // MARK: Misc
    
    func animateView() {
        dialogView.animation = "zoomIn"
        dialogView.animate()
    }

   
    
}