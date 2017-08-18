//
//  RoomLocation.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/2/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import CoreData
import MBProgressHUD

class RoomLocation: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var Label: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var categoryNameLabel = String()
    var auditorText2 = String()
    var auditNameLabel = String()
    var selectedLocation : LocationModel?
    var currentCategory : CategoryModel!
    var currentAudit : AuditModel!
    var newName = String()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Locations"
        Label.text = categoryNameLabel
        for room in currentCategory.locations {
            room.parentCategory = currentCategory
        }
        tableView.delegate = self
        tableView.dataSource = self
        // Sorting the Rooms by name:
        currentCategory.locations.sort(by :{$0.name < $1.name})
        NSLog("\(currentCategory.locations)")
        
        // ########################################### Updating core Data ########################################################################
        var namesInRoomLocation = String()
        namesInRoomLocation = "\(currentCategory.locations)"
        
        var duplicates = String()
        
        ////// Must Fetch Data in order to be able to determine if object is already in data base or if it needs to be created.
        
        // Fetch Request:
        let fetchRequestLoc: NSFetchRequest<Location> = Location.fetchRequest()
        let searchResults = try? DatabaseController.getContext().fetch(fetchRequestLoc)
        
            if searchResults?.count != 0 {
                for result in searchResults! as [Location]{
                    for item in result.entity.attributesByName.keys{
                        duplicates.append(item)
                    }
                }
                if namesInRoomLocation != duplicates {
                    let entityLocation: Location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: DatabaseController.getContext()) as! Location
                    entityLocation.locationName = namesInRoomLocation
                    DatabaseController.saveContext()
                }
            } else {
                let entityLocation: Location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: DatabaseController.getContext()) as! Location
                entityLocation.locationName = namesInRoomLocation
                DatabaseController.saveContext()
            }
            
        
        
        /// Fetching Data to make sure no duplicates were formed...Delete the next 5 lines when finished making all the necessary updates
        let fetchRequestLoc2: NSFetchRequest<Location> = Location.fetchRequest()
        let searchResults2 = try? DatabaseController.getContext().fetch(fetchRequestLoc2)
        for result in searchResults2! as [Location]{
            print("TEST123Location \(result.locationName!)")
        }
        
        //#######################################################################################################################################
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
            DestViewController.RoomLocationLabel = selectedLocation!.name
            DestViewController.CategoryLabel = categoryNameLabel
            DestViewController.AuditNameLabel = auditNameLabel
            DestViewController.currentLocation = selectedLocation!
            DestViewController.currentAudit = currentAudit!
            
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Renaming Action
        let renameAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.animationType = MBProgressHUDAnimation.zoomIn
            
            self.selectedLocation = self.currentCategory.locations[indexPath.row]
            let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedLocation!.name): ", preferredStyle: UIAlertControllerStyle.alert)
            renameAlert.addTextField(configurationHandler: nil)
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
               /// Do nothing here
                MBProgressHUD.hide(for: self.view, animated: true)
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                self.newName = (renameAlert.textFields![0].attributedText?.string)!
                
                self.currentCategory.locations[indexPath.row].name = self.newName
                tableView.cellForRow(at: indexPath)?.textLabel!.text = self.newName
                
                self.currentAudit?.save()
                
                // Sorting the Rooms by name & reloading the list:
                self.currentCategory.locations.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentCategory.locations)")
                tableView.reloadData()
                
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
                
            }))
            
            self.present(renameAlert, animated: true, completion: nil)
        })
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.animationType = MBProgressHUDAnimation.zoomIn
            /// Implementing Warning Message
            let deleteAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.currentCategory.locations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.currentAudit?.save()
                
                // MUST IMPLEMENT DELETING LOGIC HERE FOR PICTURES
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
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
        let insertAction = UITableViewRowAction(style: .default, title: "Insert", handler: { (action, indexPath) in
            // Begining of Progress Circle
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.animationType = MBProgressHUDAnimation.zoomIn
            // Inserting Alert
            let newLocAlert = UIAlertController(title: "New Location", message: "Please input a new location name:", preferredStyle: UIAlertControllerStyle.alert)
            newLocAlert.addTextField(configurationHandler: nil)
            
            newLocAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            newLocAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newLocName = newLocAlert.textFields![0].attributedText?.string
                self.currentCategory.locations.append(LocationModel(withName: newLocName!))
                
                self.currentAudit?.save()
                
                // Sorting the Rooms by name & reloading the List:
                self.currentCategory.locations.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentCategory.locations)")
                tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true) // stops the progress circle
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            self.present(newLocAlert, animated: true, completion: nil)
        })
        
        // determing the colors of each button
        insertAction.backgroundColor = UIColor.lightGray
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        
        return [insertAction, renameAction, deleteAction]
        
    }

    // The method below will get the Document Directory so pictures can be saved there
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // The method below will get retreve saved images
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}




