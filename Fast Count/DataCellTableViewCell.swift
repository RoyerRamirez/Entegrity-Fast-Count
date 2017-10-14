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
    var isDefaultKey: Bool!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
        dataTextField.delegate = self

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DataCellTableViewCell.labelTapped))
        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 1
        label.addGestureRecognizer(gestureRecognizer)
        
       
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
	
    func setupCell(key: String, parent: RoomDetailView, isDefaultKey: Bool){
        self.parent = parent
        self.label.text = key + ":"
        if let value = parent.currentLocation.data[key] {
            self.dataTextField.text = value
        }
        self.dataTextField.placeholder = key
        self.dataTextField.attributeKey = key
        self.isDefaultKey = isDefaultKey
    }

    func labelTapped(){
        if isDefaultKey { // We don't want to let users adjust default keys
            return
        }

        let deleteRowAlert = UIAlertController(title: nil, message: "Delete or rename custom data?", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let renameAction = UIAlertAction(title: "Rename", style: .default, handler: {action in
            self.renameKey()
        })

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.parent.removeCustomData(key: self.dataTextField.attributeKey)
        })

        deleteRowAlert.addAction(cancelAction)
        deleteRowAlert.addAction(renameAction)
        deleteRowAlert.addAction(deleteAction)

        parent.present(deleteRowAlert, animated: true)
    }

    func renameKey(){
        let renameRowAlert = UIAlertController(title: "Rename Custom Data", message: "Enter new title for custom data", preferredStyle: UIAlertControllerStyle.alert)

        let addAction = UIAlertAction(title: "Rename", style: .default, handler: {(action: UIAlertAction!) in
            let key = renameRowAlert.textFields![0].text!
            self.parent.renameCustomDataKey(oldKey: self.dataTextField.attributeKey, newKey: key)
            print("Rename tapped")
        })

        addAction.isEnabled = false

        renameRowAlert.addTextField(configurationHandler: {(field: UITextField) in
            field.placeholder = "Title"

            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: field, queue: OperationQueue.main, using: {notification in
                addAction.isEnabled = field.text != ""
            })
        })

        renameRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        renameRowAlert.addAction(addAction)

        parent.present(renameRowAlert, animated: true, completion: nil)
    }
}
