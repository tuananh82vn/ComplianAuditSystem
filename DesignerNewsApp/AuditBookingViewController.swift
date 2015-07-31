//
//  AuditBookingViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 31/07/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit

class AuditBookingViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView1: UITableView!
    
    var AuditActivityUrlId : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(AuditActivityUrlId)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            var cell1 = self.tableView1.dequeueReusableCellWithIdentifier("BookingCell") as! AuditRequestDetailViewCell
        
            return cell1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("You selected cell #\(indexPath.row)!")
    }
}
