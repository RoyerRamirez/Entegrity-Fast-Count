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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "AddToTableViewAudit"{
			
            let DestViewController : ViewAudit = segue.destination as! ViewAudit
			DestViewController.LabelText = TextField.text!
            DestViewController.auditorText = textField2.text!
			let newAudit = AuditModel(withName: TextField.text!)
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
            
            AuditModel.saveAuditsToUserDefaults()
            TextField.text = ""
            textField2.text = ""
			DestViewController.currentAudit = newAudit
        }
    }
    
    /*
    // Creating a New Image Directory for every new Audit
    private func createImagesFolder() {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let imagesDirectoryPath = documentDirectoryPath.appending(TextField.text!)
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating new folder for this audit failed in documents dir: \(error)")
                }
            }
        }
    }*/
}


