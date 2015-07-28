//
//  DateUtils.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 02/10/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import Foundation

extension NSDate {
    
    // -> Date System Formatted Medium
    func ToDateMediumString() -> NSString? {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat =  NSDateFormatter.dateFormatFromTemplate("MMddyyyy", options: 0, locale: NSLocale(localeIdentifier: "en-AU"))
        return formatter.stringFromDate(self)
    }
}