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
    
    var audits : [AuditModel]!
    var selectedAudit : AuditModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audits = AuditModel.getAuditsFromUserDefaults()
        
        
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
        return audits.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(audits[indexPath.item])"
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAudit = audits[indexPath.item]
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
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.performSegue(withIdentifier: "toEdit", sender: Any?.self)
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.audits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AuditModel.saveAuditsToUserDefaults(self.audits)
            
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }

    // The method below works for deleting rows
    
    //func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
       // if editingStyle == .delete {
          //  audits.remove(at: indexPath.row)
          //  tableView.deleteRows(at: [indexPath], with: .fade)
          //  AuditModel.saveAuditsToUserDefaults(audits)
    
            //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.)
            
       // }
   // }
}

