//
//  ExistingAuditListViewController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class ExistingAuditListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    //var audits : [AuditModel]!
    var selectedAudit : AuditModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Existing Audits"
        AuditModel.loadAuditsFromUserDefaults()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        else if segue.identifier == "toEdit" {
			
            let destVC = segue.destination as! FirstEditModeViewController
			destVC.currentAudit = selectedAudit
            
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
            print("Handle email Logic here")
            tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
            
        })
		
        // Colors
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        emailAction.backgroundColor = UIColor.black
        
        return [emailAction, renameAction, deleteAction]
    }
}

