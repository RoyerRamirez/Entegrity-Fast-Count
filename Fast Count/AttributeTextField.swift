//
//  AttributeTextField.swift
//  Fast Count
//
//  Created by Jasper on 7/17/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

@IBDesignable class AttributeTextField: UITextField {
    
    

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // The line commented out below allows customization of the cut copy paste menu
        /*if action == #selector(copy(_:)) || action == #selector(paste(_:))  {
            return false
        }*/
        
        return false
    }


	@IBInspectable open var attributeKey : String = ""
    
    
}
