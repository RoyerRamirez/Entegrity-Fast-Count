//
//  DataHeaderTableViewCell.swift
//  Fast Count
//
//  Created by Jasper on 8/15/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class DataHeaderTableViewCell: UITableViewCell {

	@IBOutlet weak var headerLabel: UILabel!

    var parent: RoomDetailView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func addNewRowTapped(_ sender: Any) {
        let newRowAlert = UIAlertController(title: "Custom Data", message: "Enter title for custom data", preferredStyle: UIAlertControllerStyle.alert)

        let addAction = UIAlertAction(title: "Add", style: .default, handler: {(action: UIAlertAction!) in
            let key = newRowAlert.textFields![0].text!
            self.parent.addCustomData(key: key)
            print("Add tapped")
        })

        addAction.isEnabled = false

        newRowAlert.addTextField(configurationHandler: {(field: UITextField) in
            field.placeholder = "Title"

            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: field, queue: OperationQueue.main, using: {notification in
                addAction.isEnabled = field.text != ""
            })
        })

        newRowAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        newRowAlert.addAction(addAction)

        parent.present(newRowAlert, animated: true, completion: nil)
	}
}
