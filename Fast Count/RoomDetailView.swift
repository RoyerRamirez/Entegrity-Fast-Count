//
//  AuditDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class RoomDetailView: UIViewController {

    @IBOutlet var Label2: UILabel!
        
    var audits : [AuditModel]!
    var nextAudit : AuditModel!
    
    var categories : [CategoryModel]!
    var currentStepCategories : CategoryModel?
    
    var locations : [LocationModel]!
    var selectedStepLocations : LocationModel?
    
    var LabelText3 = String()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Label2.text = LabelText3
        
        /*audits = []
        categories = []
        locations = []*/
        
        
        
        navigationItem.title = "Audit Inputs Page"
               
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
