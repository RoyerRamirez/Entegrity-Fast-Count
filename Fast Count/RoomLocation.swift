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
    
    var LabelText2 = String()
    
    var categories : [CategoryModel]! = [] //##########
    
    var currentCategories : CategoryModel?
    
    var RoomsinBuilding : [LocationModel]!
    
    var selectedLocations : LocationModel?
    
    var audits : [AuditModel]! //##########
    
    var currentStepAudit : AuditModel! //############
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Room Location Page"
        
        Label.text = LabelText2
        
        RoomsinBuilding = []
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows to 3
        return RoomsinBuilding.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        myCell.textLabel!.text = "\(RoomsinBuilding[indexPath.item])"
        return myCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            
            
            self.performSegue(withIdentifier: "toEditMode2", sender: Any?.self)
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        // action three
        let addAction = UITableViewRowAction(style: .default, title: "insert", handler: { (action, indexPath) in
            print("yas")
        })
        addAction.backgroundColor = UIColor.lightGray
        
        deleteAction.backgroundColor = UIColor.red
        
        return [addAction, editAction, deleteAction]
        
    }

    
    
}
