//
//  SecondEditMode.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/5/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class SecondEditMode: UIViewController {
    @IBOutlet var SubCategoryRenaming: UITextField!
    @IBOutlet var SaveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Renaming Subcategory Page"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
