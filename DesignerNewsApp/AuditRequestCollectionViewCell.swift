//
//  AuditRequestCollectionViewCell.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 16/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditRequestCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var AuditName: UILabel!
    
    @IBOutlet weak var AuditAddress: UILabel!
    @IBOutlet weak var AuditorUser: UILabel!
    @IBOutlet weak var AuditCompanyName: UILabel!
    @IBOutlet weak var AuditStartDate: UILabel!
    @IBOutlet weak var AuditFinishDate: UILabel!
    @IBOutlet weak var QuestionSet: UILabel!
    @IBOutlet weak var Status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selected = false
    }
    
//    override var selected : Bool {
//        didSet {
//            self.backgroundColor = UIColor.blackColor()
//        }
//    }
}
