//
//  MeetingAttendanceViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MeetingAttendanceViewController: UIViewController {

    @IBOutlet weak var txt_CloseDate: UITextField!
    @IBOutlet weak var txt_OpenDate: UITextField!
    @IBOutlet weak var lbl_LeadAuditor: UILabel!
    @IBOutlet weak var lbl_SiteName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var ButtonSaveClicked: UIButton!
}
