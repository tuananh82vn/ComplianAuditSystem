//
//  RoundButton.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

@IBDesignable

class RoundButton: UIButton {
    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var isAddButton: Bool = true

    override func drawRect(rect: CGRect) {
        var path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
    }

}
