//
//  DataCellTableViewCell.swift
//  Fast Count
//
//  Created by Jasper on 8/14/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class DataCellTableViewCell: UITableViewCell, UITextFieldDelegate {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var dataTextField: AttributeTextField!
	
	var parent: RoomDetailView!
    var nextField: AttributeTextField?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        dataTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	// Autosave text
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("change")
		if let field = textField as? AttributeTextField {
			// Only need to update currentLocation for the attribute just edited.
			parent.currentLocation.data[field.attributeKey] = (field.text == nil ? "" : field.text!)
			
			parent.currentAudit!.save()
		}
		
	}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = nextField {
            next.becomeFirstResponder()
        } else {
            // close out keyboard if this cell is the last cell
            dataTextField.resignFirstResponder()
        }

        return true
    }
	
    func setupCell(key: String, parent: RoomDetailView){
        self.parent = parent
        self.label.text = key + ":"
        if let value = parent.currentLocation.data[key] {
            self.dataTextField.text = value
        }
        self.dataTextField.placeholder = key
        self.dataTextField.attributeKey = key
    }
}
