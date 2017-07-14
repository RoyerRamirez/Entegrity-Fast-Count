//
//  RoomDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class RoomDetailView: UITableViewController  {

    @IBOutlet var labels: [UILabel]!
    @IBOutlet var label2: UILabel!
    @IBOutlet var auditorName: UIView!
    
    
    var labelText3 = String() //This string has the Room Location Name
    var labelText4 = String() // This string has the category Name
    var auditorText3 = String() //This string has the auditor name
    var currentLocation : LocationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWidthsForLabels(labels: labels)
        
        let totalLabel = labelText4 + ":  " + labelText3
        label2.text = totalLabel
        navigationItem.title = "Audit Inputs Page"
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
    
}
