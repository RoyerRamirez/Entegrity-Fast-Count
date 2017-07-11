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
    var selectedLocation : LocationModel?
    var currentCategory : CategoryModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Rooms Page"
        
        Label.text = LabelText2
        
        
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
        let renameAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
            self.selectedLocation = self.currentCategory.locations[indexPath.row]
            let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedLocation!.name): ", preferredStyle: UIAlertControllerStyle.alert)
            renameAlert.addTextField(configurationHandler: nil)
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
               /// Do nothing here
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newName = renameAlert.textFields![0].attributedText?.string
                self.currentCategory.locations[indexPath.row].name = newName!
                tableView.cellForRow(at: indexPath)?.textLabel!.text = newName
                AuditModel.saveAuditsToUserDefaults()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            self.present(renameAlert, animated: true, completion: nil)
        })
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let deleteAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.currentCategory.locations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                AuditModel.saveAuditsToUserDefaults()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            self.present(deleteAlert, animated: true, completion: nil)
            /// End of Warning Message
            
        })
        
        // action three
        let insertAction = UITableViewRowAction(style: .default, title: "Insert", handler: { (action, indexPath) in
            print("Handle Insert Logic Here")
            tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
        })
        
        // determing the colors of each button
        insertAction.backgroundColor = UIColor.lightGray
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        
        return [insertAction, renameAction, deleteAction]
        
    }

    
    
}
