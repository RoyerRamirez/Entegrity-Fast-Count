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
    var auditorText = String()
    var currentAudit : AuditModel!
    var selectedCategory : CategoryModel?
    
    override func viewDidLoad() {

        navigationItem.title = "Categories"
        Label.text = LabelText // Facility Label
       for cat in currentAudit.categories {
           
            cat.parentAudit = currentAudit
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

    public func setEditing(editing: Bool, animated: Bool){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentAudit.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(currentAudit.categories[indexPath.item])"
        return myCell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCategory = currentAudit.categories[indexPath.item]
        self.performSegue(withIdentifier: "toRoomLocationView", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoomLocationView" {

            let DestViewController : RoomLocation = segue.destination as! RoomLocation
            DestViewController.LabelText2 = selectedCategory!.name
            DestViewController.auditorText2 = auditorText
            DestViewController.currentCategory = selectedCategory!
            //DestViewController.currentStepAudit = currentAudit!

        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let renameAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
           self.selectedCategory = self.currentAudit.categories[indexPath.row]
            
            let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedCategory!.name): ", preferredStyle: UIAlertControllerStyle.alert)
            renameAlert.addTextField(configurationHandler: nil)
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newName = renameAlert.textFields![0].attributedText?.string
                self.currentAudit.categories[indexPath.row].name = newName!
                tableView.cellForRow(at: indexPath)?.textLabel!.text = newName
                AuditModel.saveAuditsToUserDefaults()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            self.present(renameAlert, animated: true, completion: nil)
        })
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let deleteAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               self.currentAudit.categories.remove(at: indexPath.row)
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
            print("Handle Insert Logic here")
            tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it

         })
        
        //Colors
        renameAction.backgroundColor = UIColor.blue
        insertAction.backgroundColor = UIColor.lightGray
        deleteAction.backgroundColor = UIColor.red
        
        return [insertAction, renameAction, deleteAction]
        
    }

    
}
