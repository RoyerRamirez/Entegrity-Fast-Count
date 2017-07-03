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
    
    
    //// Variables:
    
    var LabelText = String() // Facility Label
    
    var categories : [CategoryModel]!  ///ex: ["Category1", "Category2", "Category3"]
    
    
    
    var currentAudit : AuditModel!
    
    var selectedCategories : CategoryModel?
    
    
    override func viewDidLoad() {

        
        Label.text = LabelText // Facility Label
        categories = []
        //categories = CategoryModel.getCategoriesFromUserDefaults()
        
        
        ///////////////////// Do something similar in Room Location /////////////////////////
        for category in currentAudit.categories {
            categories.append(category)
        }
        
        //////////////////////////////////////////////////////////////////////////////////////
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /////////// Added in efforts to get the new table to work
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategories = categories[indexPath.item]
        self.performSegue(withIdentifier: "toRoomLocationView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoomLocationView" {
            let DestViewController : RoomLocation = segue.destination as! RoomLocation
            DestViewController.LabelText2 = selectedCategories!.name
            DestViewController.currentCategories = selectedCategories!
        }
    }
    
}
