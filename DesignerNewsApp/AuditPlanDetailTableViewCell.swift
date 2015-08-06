//
//  AuditPlanDetailTableViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 6/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditPlanDetailTableViewCell: UITableViewCell {

    @IBOutlet  weak var bt_Delete:   UIButton!
    @IBOutlet  weak var bt_Edit:     UIButton!
    
    @IBOutlet weak var lbl_Resources: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Activity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
