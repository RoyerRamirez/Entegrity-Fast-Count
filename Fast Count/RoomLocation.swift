//
//  RoomLocation.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/2/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class RoomLocation: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var Label: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var LabelText2 = String()
    
   // var locations : [LocationModel]!
    
    var selectedLocation : LocationModel?
    
    //var categories : [CategoryModel]!
    
    var currentCategory : CategoryModel!
    
    //var audits : [AuditModel]!
    
    //var currentStepAudit : AuditModel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Room Location Page"
        
        Label.text = LabelText2
        
        //locations = []
        
        /*for location in currentStepAudit.locations {
            locations.append(location)
        }*/
        
        for room in currentCategory.locations {
            room.parentCategory = currentCategory
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows to 3
        return currentCategory.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(currentCategory.locations[indexPath.item])"
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedLocation = currentCategory.locations[indexPath.item]
        self.performSegue(withIdentifier: "toFinalView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFinalView" {
            
            let DestViewController : RoomDetailView = segue.destination as! RoomDetailView
            DestViewController.LabelText3 = selectedLocation!.name
            //DestViewController.currentStepCategories = currentCategories!
            //DestViewController.nextAudit = currentStepAudit!
            DestViewController.selectedStepLocations = selectedLocation!
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier: "toAddLocation", sender: Any?.self)
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let refreshAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.currentCategory.locations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                AuditModel.saveAuditsToUserDefaults()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            /// End of Warning Message
            
        })
        // action three
        let addAction = UITableViewRowAction(style: .default, title: "insert", handler: { (action, indexPath) in
            print("yas")
        })
        addAction.backgroundColor = UIColor.lightGray
        
        deleteAction.backgroundColor = UIColor.red
        
        return [addAction, editAction, deleteAction]
        
    }

    
    
}
