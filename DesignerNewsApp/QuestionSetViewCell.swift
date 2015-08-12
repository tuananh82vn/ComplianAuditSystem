//
//  QuestionSetViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 10/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class QuestionSetViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Question: UILabel!
    @IBOutlet weak var bt_Download: UIButton!
    @IBOutlet weak var lbl_Priority: UILabel!
    
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var lbl_Response: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var bt_Edit: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
