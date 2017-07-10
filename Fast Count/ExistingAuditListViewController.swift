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
        
        navigationItem.title = "Existing Audits Page"

        AuditModel.loadAuditsFromUserDefaults()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //////////////////// Implimenting the Edit & Done Button on the Navigation /////////
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows to 3
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
		} else if segue.identifier == "toEdit" {
			let destVC = segue.destination as! FirstEditModeViewController
			destVC.currentAudit = selectedAudit
		}
	}

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
			self.selectedAudit = AuditModel.audits[indexPath.row]
            self.performSegue(withIdentifier: "toEdit", sender: Any?.self)
        })
		
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            
            /// Implementing Warning Message
            let refreshAlert = UIAlertController(title: "Warning", message: "All data will be purged. Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                AuditModel.audits.remove(at: indexPath.row)
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
        let emailAction = UITableViewRowAction(style: .default, title: "Email", handler: { (action, indexPath) in
            print("yas")
            
        })
		
        // Colors
        editAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        emailAction.backgroundColor = UIColor.black
        
        return [emailAction, editAction, deleteAction]
    }

    
    /* The method below works for deleting rows
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            audits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AuditModel.saveAuditsToUserDefaults(audits)
    
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.)
            
        }
    }*/
    
}

