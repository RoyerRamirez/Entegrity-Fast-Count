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
    @IBOutlet var textField2: UITextField!
    
    
    override func viewDidLoad(){
        
        navigationItem.title = "New Audit"
        /*TextField.autocapitalizationType = .words
        textField2.autocapitalizationType = .words*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "AddToTableViewAudit"{
			
            let DestViewController : ViewAudit = segue.destination as! ViewAudit
			DestViewController.LabelText = TextField.text!
            DestViewController.auditorText = textField2.text!
			let newAudit = AuditModel(withName: TextField.text!, uid: AuditModel.audits.count)
			AuditModel.audits.append(newAudit)
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
                    let newCat = CategoryModel(withName: category, parent: newAudit)
                    newAudit.categories.append(newCat) //adding to categories list up above
                        for location in ["Room 1", "Room 2", "Room 3"] {
                            newCat.locations.append(LocationModel(withName: location))
                        }
            }
           // _ = AuditFilesManager.saveAudit(audit: newAudit, uid: AuditModel.audits.count)
            newAudit.save()
            TextField.text = ""
            textField2.text = ""
			DestViewController.currentAudit = newAudit
        }
    }
}


