//
//  FirstEditModeViewController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/5/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class FirstEditModeViewController: UIViewController {
    
    @IBOutlet var RenamingAudit: UITextField!
    @IBOutlet var SaveButton: UIButton!
    @IBOutlet var FacilityLabel: UILabel!
	
	var currentAudit : AuditModel!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Renaming Facility Page"
        FacilityLabel.text = currentAudit.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toExistingAudits" {
			if let newName = RenamingAudit.text {
				currentAudit.name = newName
				AuditModel.saveAuditsToUserDefaults()
			}
		}
	}
}
