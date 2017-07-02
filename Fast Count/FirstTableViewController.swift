//
//  FirstTableViewController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/29/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit

class FirstTableViewController: UITableViewController {
    
    var FirstTableArray = [String]()
    var TEST = ["1", "2","3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //// First Table:
        FirstTableArray = ["Air Handling Unit",
                           "HVAC Equipment",
                           "Boilers",
                           "Chillers",
                           "Condensers",
                           "Cooling Tower",
                           "Exhaust Fans",
                           "Fan Coils",
                           "Heat Pumps",
                           "Mixed Air Unit",
                           "Mixing Boxes",
                           "Packaged Terminal Air Conditioner",
                           "Pumps",
                           "Roof Top Handling Units",
                           "Steam Converter",
                           "Water Heaters",
                           "Vending Machine",
                           "Air Compressor (EM)"]
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return FirstTableArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        Cell.textLabel?.text = FirstTableArray[indexPath.row]
        
        return Cell
    }
    //////////
    
    
    
    
    
    
}
