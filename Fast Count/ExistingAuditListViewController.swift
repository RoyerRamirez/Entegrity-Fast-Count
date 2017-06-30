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
        
        // Do any additional setup after loading the view.
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
    
    
    
    
    }

