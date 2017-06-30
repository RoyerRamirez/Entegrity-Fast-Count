//
//  New FacilityViewFacility.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit

class NewFacilityViewController: UIViewController {
    
    
    @IBOutlet var TextField: UITextField!
    
    override func viewDidLoad(){
       
        
    }
    
    
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        //let DestViewController : ViewAudit = segue.destination as! ViewAudit
        
        //DestViewController.LabelText = TextField.text!
        
        //let newAudit = AuditModel(withName: TextField.text!) ///replaced var with let
        //var audits = AuditModel.getAuditsFromUserDefaults()
        //audits.append(newAudit)
       // AuditModel.saveAuditsToUserDefaults(audits)
        
   // }
    
    
  //// This is the same as what was commented above
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toHomePage" {
            //let ViewController = segue.destination as! ViewController}
            _ = segue.destination as! ViewController}

        if segue.identifier == "AddToTableViewAudit"{
        let DestViewController : ViewAudit = segue.destination as! ViewAudit
        
        DestViewController.LabelText = TextField.text!
        
        let newAudit = AuditModel(withName: TextField.text!) ///replaced var with let
        var audits = AuditModel.getAuditsFromUserDefaults()
        audits.append(newAudit)
        AuditModel.saveAuditsToUserDefaults(audits)
        }
        
    }
    
    
    
    
}


