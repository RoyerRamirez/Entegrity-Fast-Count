//
//  ViewAudit.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


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
        // Sorting the Category List by name:
        currentAudit.categories.sort(by :{$0.name < $1.name})
        NSLog("\(currentAudit.categories)")
        
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
            DestViewController.categoryNameLabel = selectedCategory!.name
            DestViewController.auditorText2 = auditorText
            DestViewController.auditNameLabel = Label.text!
            DestViewController.currentCategory = selectedCategory!
            DestViewController.currentAudit = currentAudit!
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Renaming Action
            let renameAction = UITableViewRowAction(style: .default, title: "\u{1F58A}\n Rename", handler: { (action, indexPath) in
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.animationType = MBProgressHUDAnimation.zoomIn
                self.selectedCategory = self.currentAudit.categories[indexPath.row]
                let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedCategory!.name): ", preferredStyle: UIAlertControllerStyle.alert)
                renameAlert.addTextField(configurationHandler: nil)
                renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                    MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                    tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
                }))
            
                renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                    let newName = renameAlert.textFields![0].attributedText?.string
                    self.currentAudit.categories[indexPath.row].name = newName!
                    tableView.cellForRow(at: indexPath)?.textLabel!.text = newName
               
                    self.currentAudit!.save()
                
                    // Sorting the Category List by name & reloading the data
                    self.currentAudit.categories.sort(by :{$0.name < $1.name})
                    NSLog("\(self.currentAudit.categories)")
                    tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                    tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
                
                }))
            
                self.present(renameAlert, animated: true, completion: nil)
            })
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .default, title: "\u{1F5D1}\n Delete", handler: { (action, indexPath) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.animationType = MBProgressHUDAnimation.zoomIn
            /// Implementing Warning Message
            let deleteAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               self.currentAudit.categories.remove(at: indexPath.row)
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.currentAudit!.save()
                
                // INSERT DELETE LOGIC HERE FOR PICTURES
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it

            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            self.present(deleteAlert, animated: true, completion: nil)
            /// End of Warning Message
            
        })
        // Insert Action
        let insertAction = UITableViewRowAction(style: .default, title: "\u{1F5C2}\n Insert", handler: { (action, indexPath) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.animationType = MBProgressHUDAnimation.zoomIn
            // Inserting Alert
            let newCatAlert = UIAlertController(title: "New Category", message: "Please input a new category name:", preferredStyle: UIAlertControllerStyle.alert)
            newCatAlert.addTextField(configurationHandler: nil)
            newCatAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            newCatAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newCatName = newCatAlert.textFields![0].attributedText?.string
                let newCat = CategoryModel(withName: newCatName!, parent: self.currentAudit)
                self.currentAudit.categories.append(newCat) //adding to categories list up above
                // Creating New Rooms for this Category
                for location in ["Room 1"] {
                    newCat.locations.append(LocationModel(withName: location))
                }
                // Saving the new category
                self.currentAudit!.save()
                
                // Sorting the Category List by name & reloading the data
                self.currentAudit.categories.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentAudit.categories)")
                tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            self.present(newCatAlert, animated: true, completion: nil)
         })
        
        //Colors & returning actions
        renameAction.backgroundColor = UIColor.blue
        insertAction.backgroundColor = UIColor.lightGray
        deleteAction.backgroundColor = UIColor.red
        return [insertAction, renameAction, deleteAction]
        
    }
}
