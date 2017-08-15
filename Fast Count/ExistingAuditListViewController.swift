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
import MBProgressHUD

class ExistingAuditListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    var selectedAudit : AuditModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Existing Audits"
        AuditModel.audits = AuditFilesManager.listAudits()
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
                self.selectedAudit?.save()
                print("There are \(AuditModel.audits.count) audits saved in Folder.")
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
               self.selectedAudit!.delete()
                AuditModel.audits.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                
                
                
               
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
			
			let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
			hud.animationType = MBProgressHUDAnimation.zoomIn
			
			DispatchQueue.main.async(){
				let mailComposeViewController = self.configuredMailComposeViewController(audit: AuditModel.audits[indexPath.row])
				
				if MFMailComposeViewController.canSendMail(){
					self.present(mailComposeViewController, animated: true, completion: nil)
				} else{
					// error logic goes here
				}
				
				tableView.setEditing(false, animated: true) // hides the slide out bar after pressing on it
			}
        })
		
        // Colors
        renameAction.backgroundColor = UIColor.blue
        deleteAction.backgroundColor = UIColor.red
        emailAction.backgroundColor = UIColor.black
        
        return [emailAction, renameAction, deleteAction]
    }
    
	func configuredMailComposeViewController(audit: AuditModel) -> MFMailComposeViewController {
        // Establish the controller from scratch
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        // Set preset information included in the email
        mailComposerVC.setSubject("Audit CSV")
        mailComposerVC.setMessageBody("The Audit CSV File is attached to this email.", isHTML: false)
		
        let data = CSVExport.exportCSV(audit: audit)
		let archiveData = FileManager.default.contents(atPath: data.imagesArchive.path)!
//		let archiveData = try! Data(contentsOf: data.imagesArchive)
        mailComposerVC.addAttachmentData(data.data!, mimeType: "text/csv",
			fileName: "audit_\(audit.name.replacingOccurrences(of: " ", with: "_")).csv")
		mailComposerVC.addAttachmentData(archiveData, mimeType: "application/zip", fileName: data.imagesArchive.lastPathComponent)
		
        return mailComposerVC
    }
	
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
		MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}


