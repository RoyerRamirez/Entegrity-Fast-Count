//
//  RoomDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class RoomDetailView: UITableViewController  {

    @IBOutlet var labels: [UILabel]! //Photo Gallary Label
    @IBOutlet var label2: UILabel! // Header Label
    
   // var for every input:
    @IBOutlet var servesTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var makeTextField: UITextField!
    @IBOutlet var modelTextField: UITextField!
    @IBOutlet var serialTextField: UITextField!
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var voltageTextField: UITextField!
    @IBOutlet var phaseTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var conditionTextField: UITextField!
    @IBOutlet var auditorTextField: UITextField!
    @IBOutlet var efficiencyTextField: UITextField!
    @IBOutlet var notesTextField: UITextField!
    
    
    var currentLocation : LocationModel!
    var labelText3 = String() //This string has the Room Location Name
    var labelText4 = String() // This string has the category Name
    var auditorText3 = String() //This string has the auditor name
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthsForLabels(labels: labels)
        
        let totalLabel = labelText4 + ":  " + labelText3
        label2.text = totalLabel
        auditorTextField.text = auditorText3
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
    func textFieldDidChange(_ textField: UITextField) {
        AuditModel.saveAuditsToUserDefaults()
    }
    
}
