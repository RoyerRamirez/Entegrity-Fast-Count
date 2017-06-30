//
//  ThirdView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/29/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    
    @IBOutlet var TextField: UITextField!
    
    @IBOutlet var TextView: UITextView! //Text view for notes
    
    var FirstString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextView.text = FirstString
    }
}
