//
//  MeetingDetailsViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 7/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class MeetingDetailsViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var bt_Delete: UIButton!
    @IBOutlet weak var bt_Edit: UIButton!
    
    @IBOutlet weak var lbl_Close: UILabel!
    @IBOutlet weak var lbl_Open: UILabel!
    @IBOutlet weak var lbl_Position: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_number: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
