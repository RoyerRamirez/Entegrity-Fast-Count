//
//  ExistingAuditListViewController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import MessageUI

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
            
            //******************************************* Stil Needs Work: Email CSV Strings **************************************************************************************
            let fileName = "\(AuditModel.audits[indexPath.item]).csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            var csvText = "Entegrity,Energy,Partners\n\(AuditModel.audits),\(self.selectedAudit?.categories),\(self.selectedAudit?.locations)\n\nDate,Mileage,Gallons,Price,Price per gallon,Miles between fillups,MPG\n"
            
            self.selectedAudit?.categories.sort(by: { $0.name.compare($1.name) == .orderedDescending })
            
            
            let count = self.selectedAudit?.categories.count
            
            if count! >= 0 {
                
                
                    
                    let newLine = "\(self.selectedAudit?.categories),\(self.selectedAudit?.locations)\n"
                    
                    csvText.append(newLine)
            
                
                do {
                    try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                    
                    let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                    vc.excludedActivityTypes = [
                        UIActivityType.assignToContact,
                        UIActivityType.saveToCameraRoll,
                        UIActivityType.postToFlickr,
                        UIActivityType.postToVimeo,
                        UIActivityType.postToTencentWeibo,
                        UIActivityType.postToTwitter,
                        UIActivityType.postToFacebook,
                        UIActivityType.openInIBooks
                    ]
                    self.present(vc, animated: true, completion: nil)
                    
                } catch {
                    
                    print("Failed to create CSV file")
                    print("\(error)")
                }
                
            }
            else {
                let alertController = UIAlertController(title: "Error", message: "There is no data to export", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            
            //****************************************************************************************************************************************************************************
            
            tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            
        })
		
        // Colors
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        emailAction.backgroundColor = UIColor.black
        
        return [emailAction, renameAction, deleteAction]
    }
    
}


