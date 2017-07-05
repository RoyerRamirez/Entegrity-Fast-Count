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

        if segue.identifier == "AddToTableViewAudit"{
        let DestViewController : ViewAudit = segue.destination as! ViewAudit
        
        DestViewController.LabelText = TextField.text!
        
          
            
        let newAudit = AuditModel(withName: TextField.text!) ///replaced var with let
        var audits = AuditModel.getAuditsFromUserDefaults()
        audits.append(newAudit)
            
            ///// Set something similar here for RoomLocation //////////////////////////////////
            let CategoriesAutoLoad = ["Air Handling Unit",
                                      "HVAC Equipment",
                                      "Boilers",
                                      "Chillers",
                                      "Condensers",
                                      "Cooling Tower",
                                      "Exhaust Fans",
                                      "Fan Coils",
                                      "Heat Pumps",
                                      "Mixed Air Unit",
                                      "Mixing Boxes",
                                      "Packaged Terminal Air Conditioner",
                                      "Pumps",
                                      "Roof Top Handling Units",
                                      "Steam Converter",
                                      "Water Heaters",
                                      "Vending Machine",
                                      "Air Compressor (EM)"]

            
            for category in CategoriesAutoLoad {
                
                newAudit.categories.append(CategoryModel(withName: category)) //adding to categories list up above
            }

            
            AuditModel.saveAuditsToUserDefaults(audits)
            
            TextField.text = ""

        DestViewController.currentAudit = newAudit
            
            
            
            
        }
        
    }
    
    
    
    
}


