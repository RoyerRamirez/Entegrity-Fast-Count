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
    
   // var categories : [CategoryModel]!  ///ex: ["Category1", "Category2", "Category3"]
    
    //var audits : [AuditModel]! //##########
    
    var currentAudit : AuditModel!
    
    var selectedCategory : CategoryModel?
    
    
    
    
    
   
    
    
    override func viewDidLoad() {

        navigationItem.title = "Audit Details Page"
        
        Label.text = LabelText // Facility Label
        //categories = []
        //categories = CategoryModel.getCategoriesFromUserDefaults()
        
        for cat in currentAudit.categories {
            cat.parentAudit = currentAudit
        }
        
        ///////////////////// Loading List of Categories /////////////////////////
       /* for category in currentAudit.categories {
            AuditModel.categories.append(category)
        }
        */
        //////////////////////////////////////////////////////////////////////////////////////
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //////////////////// Implimenting the Edit & Done Button on the Navigation /////////
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setEditing(editing: Bool, animated: Bool){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows 
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
            DestViewController.currentCategory = selectedCategory!
            //DestViewController.currentStepAudit = currentAudit!

            }
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
           
            
            self.performSegue(withIdentifier: "toEditMode2", sender: Any?.self)
        })
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let refreshAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               self.currentAudit.categories.remove(at: indexPath.row)
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
        let addAction = UITableViewRowAction(style: .default, title: "Insert", handler: { (action, indexPath) in
            print("yas")

         })
        
        //Colors
        editAction.backgroundColor = UIColor.blue
        addAction.backgroundColor = UIColor.lightGray
        deleteAction.backgroundColor = UIColor.red
        
        return [addAction, editAction, deleteAction]
        
    }

    
}
