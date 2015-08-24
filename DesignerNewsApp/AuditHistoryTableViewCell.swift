//
//  AuditHistoryTableViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 24/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Comment: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
