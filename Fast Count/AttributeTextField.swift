//
//  AttributeTextField.swift
//  Fast Count
//
//  Created by Jasper on 7/17/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

@IBDesignable class AttributeTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	@IBInspectable open var attributeKey : String = ""
}
