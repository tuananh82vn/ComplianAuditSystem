//
//  BookingViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class BookingViewCell: UITableViewCell {

    @IBOutlet weak var lbl_FileName: UILabel!
    @IBOutlet weak var lbl_Notes: UILabel!
    @IBOutlet weak var lbl_Number: UILabel!
    @IBOutlet weak var lbl_Item: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
