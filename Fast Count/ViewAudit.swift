//
//  ViewAudit.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit

/// Lists the categories
class ViewAudit: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var Label: UILabel! // Facility Label
    
    
    @IBOutlet var tableView: UITableView!
    
    var LabelText = String() // Facility Label
    
    var categories : [CategoryModel]!  ///ex: ["Category1", "Category2", "Category3"]
    
    var currentAudit : AuditModel!
    
    
    

    
    
    override func viewDidLoad() {

        
        Label.text = LabelText // Facility Label
        categories = []
//        categories = CategoryModel.getCategoriesFromUserDefaults()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows to 3
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(categories[indexPath.item])"
        return myCell
    }
    
    
}
