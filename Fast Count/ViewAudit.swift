//
//  ViewAudit.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
        
        // ########################################### Updating core Data ########################################################################
       /* var namesInCategory = String()
        namesInCategory = "\(currentAudit.categories)"
        
        var duplicates = String()
        
        ////// Must Fetch Data in order to be able to determine if object is already in data base or if it needs to be created.
        /*
        // Fetch Request:
        let fetchRequestCat: NSFetchRequest<Category> = Category.fetchRequest()
        let searchResults2 = try? DatabaseController.getContext().fetch(fetchRequestCat)
        
            if searchResults2?.count != 0 {
                for result in searchResults2! as [Category]{
                    for item in result.entity.attributesByName.keys{
                    duplicates.append(item)
                    }
                }
                if namesInCategory != duplicates {
                    let entityCategory: Category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: DatabaseController.getContext()) as! Category
                    entityCategory.categoryName = namesInCategory
                    DatabaseController.saveContext()
                }
            } else {
                let entityCategory: Category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: DatabaseController.getContext()) as! Category
                entityCategory.categoryName = namesInCategory
                DatabaseController.saveContext()
            }*/
            
        
        /*
        let audit: Audit = NSEntityDescription.insertNewObject(forEntityName: "Audit", into: DatabaseController.getContext()) as! Audit
        audit.auditName = LabelText */
        //DatabaseController.saveContext()
        
        
        // fetching the Database
                //let fetchRequest: NSFetchRequest<Audit> = Audit.fetchRequest()
        //let fetchRequestCat2: NSFetchRequest<Category> = Category.fetchRequest()
        /*
        let searchResults = try? DatabaseController.getContext().fetch(fetchRequest)
        print("Audit \(searchResults) saved in our Database sucessfully")
        for result in searchResults! as [Audit]{
            print("\(result.auditName!)")
        }*/
        
        // Pulling up what is being saving in CoreDate to make sure everything is correct. Delete the next 5 lines when finished making all the necessary updates
        /*let searchResults3 = try? DatabaseController.getContext().fetch(fetchRequestCat2)
        print("Category \(searchResults3) saved in our Database sucessfully")
        for result in searchResults3! as [Category]{
            print("TEST123 \(result.categoryName!)")
        }*/
        */
        //#######################################################################################################################################
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
               
                self.currentAudit!.save()
                
                // Sorting the Category List by name & reloading the data
                self.currentAudit.categories.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentAudit.categories)")
                tableView.reloadData()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
                
            }))
            
            self.present(renameAlert, animated: true, completion: nil)
        })
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let deleteAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
               self.currentAudit.categories.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.currentAudit!.save()

                
                // ###### Delete Logic for Core Data is below (Currently Not working properly) #######
                /*var itemBeingRequested = String()
                itemBeingRequested = "\(self.selectedCategory)"
                print("preparing to enter 'do' loop")

                //let itemBeingRequested = self.selectedCategory!.name
                /*
                    let request: NSFetchRequest<Category> = Category.fetchRequest()
                    request.predicate = NSPredicate(format:"categoryName == %@", itemBeingRequested)
                    let searchResults = try? DatabaseController.getContext().fetch(request)
                    if searchResults?.count != 0 {
                        for result in searchResults! as [Category]{
                            for item in result.entity.attributesByName.keys{
                                //DatabaseController.getContext().delete(item)
                                //DatabaseController.saveContext()

                                print("YASS!!!")
                            }
                        }
                    }
                    
                */
                 */
                // ###### End of Deleting Logic for Core Data #######
                
                // INSERT DELETE LOGIC HERE FOR PICTURES
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it

            }))
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            self.present(deleteAlert, animated: true, completion: nil)
            /// End of Warning Message
            
        })
        // Insert Action
        let insertAction = UITableViewRowAction(style: .default, title: "Insert", handler: { (action, indexPath) in
            
            // Inserting Alert
            let newCatAlert = UIAlertController(title: "New Category", message: "Please input a new category name:", preferredStyle: UIAlertControllerStyle.alert)
            newCatAlert.addTextField(configurationHandler: nil)
            newCatAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            newCatAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newCatName = newCatAlert.textFields![0].attributedText?.string
                let newCat = CategoryModel(withName: newCatName!, parent: self.currentAudit)
                self.currentAudit.categories.append(newCat) //adding to categories list up above
                // Creating New Rooms for this Category
                for location in ["Room 1", "Room 2", "Room 3"] {
                    newCat.locations.append(LocationModel(withName: location))
                }
                // Saving the new category
                self.currentAudit!.save()

                
                // Sorting the Category List by name & reloading the data
                self.currentAudit.categories.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentAudit.categories)")
                tableView.reloadData()
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
