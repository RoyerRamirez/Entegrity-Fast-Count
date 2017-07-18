//
//  RoomDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class RoomDetailView: UITableViewController, UITextFieldDelegate {

    @IBOutlet var labels: [UILabel]! //Photo Gallary Label
    @IBOutlet var label2: UILabel! // Header Label
    
   // var for every Text Field:
    @IBOutlet var servesTextField: AttributeTextField!
    @IBOutlet var idTextField: AttributeTextField!
    @IBOutlet var makeTextField: AttributeTextField!
    @IBOutlet var modelTextField: AttributeTextField!
    @IBOutlet var serialTextField: AttributeTextField!
    @IBOutlet var yearTextField: AttributeTextField!
    @IBOutlet var voltageTextField: AttributeTextField!
    @IBOutlet var phaseTextField: AttributeTextField!
    @IBOutlet var descriptionTextField: AttributeTextField!
    @IBOutlet var conditionTextField: AttributeTextField!
    @IBOutlet var auditorTextField: AttributeTextField!
    @IBOutlet var efficiencyTextField: AttributeTextField!
    @IBOutlet var notesTextField: AttributeTextField!
    @IBOutlet var imageTextField1: UITextField!
    @IBOutlet var imageTextField2: UITextField!
    @IBOutlet var imageTextField3: UITextField!
    
	var fieldArray : [AttributeTextField] {
		get {
			return [servesTextField, idTextField, makeTextField, modelTextField, serialTextField, yearTextField,
					voltageTextField, phaseTextField, descriptionTextField, conditionTextField, auditorTextField,
					efficiencyTextField, notesTextField]
		}
	}
	
    var currentLocation : LocationModel!
    var labelText3 = String() //This string has the Room Location Name
    var labelText4 = String() // This string has the category Name
    var auditorText3 = String() //This string has the auditor name
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		servesTextField.delegate = self
		idTextField.delegate = self
		makeTextField.delegate = self
		modelTextField.delegate = self
		serialTextField.delegate = self
		yearTextField.delegate = self
		voltageTextField.delegate = self
		phaseTextField.delegate = self
		descriptionTextField.delegate = self
		conditionTextField.delegate = self
		auditorTextField.delegate = self
		efficiencyTextField.delegate = self
		notesTextField.delegate = self
		
        updateWidthsForLabels(labels: labels)
        
        let totalLabel = labelText4 + ":  " + labelText3
        label2.text = totalLabel
        auditorTextField.text = auditorText3
        
        //Giving each picture a unique name
        let totalImageLabel = labelText4 + "." + labelText3
        let totalImageLabelTrim = String(totalImageLabel.characters.filter { !" \n\t\r".characters.contains($0) })
        imageTextField1.text = totalImageLabelTrim + ".1"
        imageTextField2.text = totalImageLabelTrim + ".2"
        imageTextField3.text = totalImageLabelTrim + ".3"
		
		// Load currentLocation.data
		for field in fieldArray {
			field.text = (currentLocation.data[field.attributeKey] == nil ? "" : currentLocation.data[field.attributeKey]!)
		}
		
        navigationItem.title = "Audit Detailed Inputs"
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // method below calculates the label width
    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        return labelSize.width
    }
    
    // method below finds the max width of labels
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        //return reduce(map(labels, calculateLabelWidth), 0, max)
        return labels.map(calculateLabelWidth).reduce(0, max)
    }
    
    // method below adds Auto Layout constraints to constrain the labels
    private func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    // This method should loop through each text field then hide the keyboard (pressing enter key)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
			case servesTextField: idTextField.becomeFirstResponder() // passes each textField to next
			case idTextField: makeTextField.becomeFirstResponder()
			case makeTextField: modelTextField.becomeFirstResponder()
			case modelTextField: serialTextField.becomeFirstResponder()
			case serialTextField: yearTextField.becomeFirstResponder()
			case yearTextField: voltageTextField.becomeFirstResponder()
			case voltageTextField: phaseTextField.becomeFirstResponder()
			case phaseTextField: descriptionTextField.becomeFirstResponder()
			case descriptionTextField: conditionTextField.becomeFirstResponder()
			case conditionTextField: efficiencyTextField.becomeFirstResponder()
			case efficiencyTextField: notesTextField.becomeFirstResponder()
			default: efficiencyTextField.resignFirstResponder() //closes out the keyboard at the end
        }
		
        return true
    }
    
    // This method should autosave the text
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("change")
		if let field = textField as? AttributeTextField {
			// Only need to update currentLocation for the attribute just edited.
			currentLocation.data[field.attributeKey] = (field.text == nil ? "" : field.text!)
			AuditModel.saveAuditsToUserDefaults()
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
