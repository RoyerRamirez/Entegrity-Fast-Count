//
//  ExistingAuditListViewController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class ExistingAuditListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var selectedAudit : AuditModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Existing Audits"
        AuditModel.loadAuditsFromUserDefaults()
        tableView.delegate = self
        tableView.dataSource = self
        // Sorting the Category List by name:
        AuditModel.audits.sort(by :{$0.name < $1.name})
        NSLog("\(AuditModel.audits)")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuditModel.audits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(AuditModel.audits[indexPath.item])"
        return myCell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAudit = AuditModel.audits[indexPath.item]
        self.performSegue(withIdentifier: "toViewAudit", sender: self)
        
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewAudit" {
            let DestViewController : ViewAudit = segue.destination as! ViewAudit
			DestViewController.LabelText = selectedAudit!.name
			DestViewController.currentAudit = selectedAudit!
		}
	}

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // action one
		let renameAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
            self.selectedAudit = AuditModel.audits[indexPath.row]
            let renameAlert = UIAlertController(title: "Rename", message: "Rename \(self.selectedAudit!.name): ", preferredStyle: UIAlertControllerStyle.alert)
			renameAlert.addTextField(configurationHandler: nil)
			
            renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
				 tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
			}))
			
			renameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
                let newName = renameAlert.textFields![0].attributedText?.string
				AuditModel.audits[indexPath.row].name = newName!
				tableView.cellForRow(at: indexPath)?.textLabel!.text = newName
				AuditModel.saveAuditsToUserDefaults()
                // Sorting the Audit List by name & reloading all Audits:
                AuditModel.audits.sort(by :{$0.name < $1.name})
                NSLog("\(AuditModel.audits)")
                tableView.reloadData()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
			
			self.present(renameAlert, animated: true, completion: nil)
		})
		
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let refreshAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                AuditModel.audits.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                AuditModel.saveAuditsToUserDefaults()
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            /// End of Warning Message
            
        })
		
        // action three
        let emailAction = UITableViewRowAction(style: .default, title: "Email", handler: { (action, indexPath) in
            
            //############################# Working with Core Data ###################################################
            let audit:Audit = NSEntityDescription.insertNewObject(forEntityName: "Audit", into: DatabaseController.getContext()) as! Audit
            audit.auditName = self.selectedAudit?.name
            
            
            /*
            var categoriesInAudit = String()
            categoriesInAudit = "\(self.selectedAudit?.categories[indexPath.item])"
            let category:Category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: DatabaseController.getContext()) as! Category
            category.categoryName =  categoriesInAudit
            
            var locationsInAudit = String()
            locationsInAudit = "\(self.selectedAudit?.locations[indexPath.item])"
            let location:Location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: DatabaseController.getContext()) as! Location
            location.locationName =  locationsInAudit
            
            */
            
            
            
            // Saving to Database
            DatabaseController.saveContext()
            
            // fetching the Database
            let fetchRequest: NSFetchRequest<Audit> = Audit.fetchRequest()
            
            let searchResults = try? DatabaseController.getContext().fetch(fetchRequest)
            print("Audit \(searchResults) saved in our Database sucessfully")
            for result in searchResults! as [Audit]{
                print("\(result.auditName!)")
            }

            
            
            
            
            
//******************************************* Stil Needs Work: Email CSV Strings **************************************************************************************
            
            
//*********************************************************************************************************************************************************************
            
            tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            
        })
		
        // Colors
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        emailAction.backgroundColor = UIColor.black
        
        return [emailAction, renameAction, deleteAction]
    }
    
}


