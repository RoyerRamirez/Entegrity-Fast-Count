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
    
    var categoryNameLabel = String()
    var auditorText2 = String()
    var auditNameLabel = String()
    //var auditNAmeChange = String() ################################
    var selectedLocation : LocationModel?
    var currentCategory : CategoryModel!
    var audits : AuditModel!
    var newName = String()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    //var backgroundTasks : UIBackgroundTaskIdentifier!
    

    override func viewDidLoad() {
        //print(auditNAmeChange) ################################
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
            DestViewController.auditorText3 = auditorText2
            //DestViewController.auditNameChange = auditNAmeChange ################################
            DestViewController.AuditNameLabel = auditNameLabel
            DestViewController.currentLocation = selectedLocation!
            
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Renaming Action
        let renameAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
            self.selectedLocation = self.currentCategory.locations[indexPath.row]
            let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedLocation!.name): ", preferredStyle: UIAlertControllerStyle.alert)
            renameAlert.addTextField(configurationHandler: nil)
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
               /// Do nothing here
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                self.newName = (renameAlert.textFields![0].attributedText?.string)!
                
                // Recreating Name:
                    // Pic one:
                    let name1 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".1"
                    let trim1 = String(name1.characters.filter { !" \n\t\r".characters.contains($0) })
                    let oldImage1 = "image_\(trim1).png"
                    // Pic Two:
                    let name2 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".2"
                    let trim2 = String(name2.characters.filter { !" \n\t\r".characters.contains($0) })
                    let oldImage2 = "image_\(trim2).png"
                    // Pic Three:
                    let name3 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".3"
                    let trim3 = String(name3.characters.filter { !" \n\t\r".characters.contains($0) })
                    let oldImage3 = "image_\(trim3).png"
                    // Pic Four:
                    let name4 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".4"
                    let trim4 = String(name4.characters.filter { !" \n\t\r".characters.contains($0) })
                    let oldImage4 = "image_\(trim4).png"
                
                
                
                // Renaming Image & Deleting Old Pics:
                // Pic One:
                if let image = self.getSavedImage(named: oldImage1){
                    // creating new name
                    let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".1"
                    let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
                    let newImageName1 = "image_\(newImageNameTrim).png"
                    
                    // Over writing old image name with new one:
                    let data = UIImagePNGRepresentation(image)
                    let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName1)
                    try? data?.write(to: filename)
                    print("Just Finished 1st loop")
                }
                // Pic Two:
                if let image = self.getSavedImage(named: oldImage2){
                    // creating new name
                    let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".2"
                    let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
                    let newImageName2 = "image_\(newImageNameTrim).png"
                    
                    // Over writing old image name with new one:
                    let data = UIImagePNGRepresentation(image)
                    let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName2)
                    try? data?.write(to: filename)
                    print("Just Finished 2nd loop")
                }
                // Pic Three:
                if let image = self.getSavedImage(named: oldImage3){
                    // creating new name
                    let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".3"
                    let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
                    let newImageName3 = "image_\(newImageNameTrim).png"
                    
                    // Over writing old image name with new one:
                    let data = UIImagePNGRepresentation(image)
                    let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName3)
                    try? data?.write(to: filename)
                    print("Just Finished 3rd loop")
                }
                // Pic Four:
                if let image = self.getSavedImage(named: oldImage4){
                    // creating new name
                    let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".4"
                    let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
                    let newImageName4 = "image_\(newImageNameTrim).png"
                    
                    // Over writing old image name with new one:
                    let data = UIImagePNGRepresentation(image)
                    let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName4)
                    try? data?.write(to: filename)
                    print("Just Finished 4th loop")
                }

                
                self.currentCategory.locations[indexPath.row].name = self.newName
                tableView.cellForRow(at: indexPath)?.textLabel!.text = self.newName
                AuditModel.saveAuditsToUserDefaults()
                // Sorting the Rooms by name & reloading the list:
                self.currentCategory.locations.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentCategory.locations)")
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
                self.currentCategory.locations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                AuditModel.saveAuditsToUserDefaults()
                // MUST IMPLEMENT DELETING LOGIC HERE FOR PICTURES
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
            let newLocAlert = UIAlertController(title: "New Location", message: "Please input a new location name:", preferredStyle: UIAlertControllerStyle.alert)
            newLocAlert.addTextField(configurationHandler: nil)
            
            newLocAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            newLocAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newLocName = newLocAlert.textFields![0].attributedText?.string
                self.currentCategory.locations.append(LocationModel(withName: newLocName!))
                AuditModel.saveAuditsToUserDefaults()
                // Sorting the Rooms by name & reloading the List:
                self.currentCategory.locations.sort(by :{$0.name < $1.name})
                NSLog("\(self.currentCategory.locations)")
                tableView.reloadData()
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
    
    // The method below will run tasks in the background to help save time
    
    /*
    func appDidEnterBackground(_ application: UIApplication) {
        beginBackgroundTask()
    }
    func beginBackgroundTask(){
        print("App entered Background")
        /// Recreating Old Names for Images
        let totalImageLabel1 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".1"
        let totalImageLabel2 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".2"
        let totalImageLabel3 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".3"
        let totalImageLabel4 = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.selectedLocation!.name + ".4"
        print("how much time left")
        let totalImageLabelTrim1 = String(totalImageLabel1.characters.filter { !" \n\t\r".characters.contains($0) })
        let totalImageLabelTrim2 = String(totalImageLabel2.characters.filter { !" \n\t\r".characters.contains($0) })
        let totalImageLabelTrim3 = String(totalImageLabel3.characters.filter { !" \n\t\r".characters.contains($0) })
        let totalImageLabelTrim4 = String(totalImageLabel4.characters.filter { !" \n\t\r".characters.contains($0) })
        let oldImageName1 = "image_\(totalImageLabelTrim1).png"
        let oldImageName2 = "image_\(totalImageLabelTrim2).png"
        let oldImageName3 = "image_\(totalImageLabelTrim3).png"
        let oldImageName4 = "image_\(totalImageLabelTrim4).png"
        print("Just Finished Making old Names")
        
        // If the image exist it will go into the loop
        if let image = self.getSavedImage(named: oldImageName1){
            // creating new name
            let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".1"
            let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
            let newImageName1 = "image_\(newImageNameTrim).png"
            
            // Over writing old image name with new one:
            let data = UIImagePNGRepresentation(image)
            let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName1)
            try? data?.write(to: filename)
            print("Just Finished 1st loop")
        }
        
        
        // Seond Image Loop
        if let image = self.getSavedImage(named: oldImageName2){
            // creating new name
            let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".2"
            let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
            let newImageName1 = "image_\(newImageNameTrim).png"
            
            // Over writing old image name with new one:
            let data = UIImagePNGRepresentation(image)
            let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName1)
            try? data?.write(to: filename)
            print("Just Finished 2nd loop")
        }
        // Third Image Loop
        if let image = self.getSavedImage(named: oldImageName3){
            // creating new name
            let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".3"
            let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
            let newImageName1 = "image_\(newImageNameTrim).png"
            
            // Over writing old image name with new one:
            let data = UIImagePNGRepresentation(image)
            let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName1)
            try? data?.write(to: filename)
            print("Just Finished 3rd loop")
        }
        // Fourth Image Loop
        if let image = self.getSavedImage(named: oldImageName4){
            // creating new name
            let newImageName = self.auditNameLabel + "." + self.categoryNameLabel + "." + self.newName + ".4"
            let newImageNameTrim = String(newImageName.characters.filter { !" \n\t\r".characters.contains($0) })
            let newImageName1 = "image_\(newImageNameTrim).png"
            
            // Over writing old image name with new one:
            let data = UIImagePNGRepresentation(image)
            let filename = self.getDocumentsDirectory().appendingPathComponent(newImageName1)
            try? data?.write(to: filename)
            print("Just Finished 4th loop")
            
        }

    // Calling the Terminating method to end background tasks
       // self.appDidExitBackground()
        
    }
    
    // This method will Terminate the background tasks
    func appDidExitBackground() {
        UIApplication.shared.endBackgroundTask(backgroundTasks)
        backgroundTasks = UIBackgroundTaskInvalid
    } */
    

    
    // Better way of looking for files inside Documents Directory
    /*
    func enumerateDirectory() -> String? {
        var error: NSError?
        let filesInDirectory =  fileManager.contentsOfDirectoryAtPath(tmpDir, error: &error) as? [String]
        
        if let files = filesInDirectory {
            if files.count > 0 {
                if files[0] == fileName {
                    println("sample.txt found")
                    return files[0]
                } else {
                    println("File not found")
                    return nil
                }
            }
        }
        return nil
    } */
    
}




