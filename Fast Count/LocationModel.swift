//
//  LocationsModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class LocationModel: NSObject, NSCoding {
	// All locations will display these keys in RoomDetailView even if they are blank.
	static let defaultKeys = ["Serves", "ID", "Make", "Model", "Serial", "Year", "Voltage", "Phase",
	                          "Description", "Condition", "Auditor", "Efficiency", "Notes"]

    var name : String
    var data : [String:String] // Dictioary
    var parentCategory : CategoryModel?
	
    var image1 : UIImage?
    var image2 : UIImage?
    var image3 : UIImage?
    var image4 : UIImage?
    
    var image1Id : Int?
    var image2Id : Int?
    var image3Id : Int?
    var image4Id : Int?
    
    // Set to true before saving if changes made were to images
    var saveImages: Bool = false
    // Depecrated, should be removed soon
    var lastChange : ChangeType!

	
	// Calculates all keys in data that aren't in defaultKeys
	var customKeys: [String] {
		get {
			var customKeys: [String] = []
			for (key, _) in data {
				if !LocationModel.defaultKeys.contains(key) {
					customKeys.append(key)
				}
			}
			
			return customKeys
		}
	}
    
    override var description: String {
        get {
            return self.name
        }
    }
    
	init(withName name:String) {
        self.name = name
        data = [:]
    }

	convenience init(withName name: String, auditor: String){
		self.init(withName: name)
		if auditor != "" {
			data["Auditor"] = auditor
		}
	}
	
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            name = ""
        }
        
        if let data = aDecoder.decodeObject(forKey: "data") as? [String:String] {
            self.data = data
        } else {
            data = [:]
        }
        
        if let id = aDecoder.decodeObject(forKey: "image1Id") as? Int {
            self.image1Id = id
        }
        
        if let id = aDecoder.decodeObject(forKey: "image2Id") as? Int {
            self.image2Id = id
        }
        
        if let id = aDecoder.decodeObject(forKey: "image3Id") as? Int {
            self.image3Id = id
        }
        
        if let id = aDecoder.decodeObject(forKey: "image4Id") as? Int {
            self.image4Id = id
        }
        
        // Also about to be depecrated ----------------------------------------------
            if let image = aDecoder.decodeObject(forKey: "image1") as? UIImage {
                self.image1 = image
            } else {
                image1 = nil
            }
            
            if let image = aDecoder.decodeObject(forKey: "image2") as? UIImage {
                self.image2 = image
            } else {
                image2 = nil
            }
            
            if let image = aDecoder.decodeObject(forKey: "image3") as? UIImage {
                self.image3 = image
            } else {
                image3 = nil
            }
            
            if let image = aDecoder.decodeObject(forKey: "image4") as? UIImage {
                self.image4 = image
            } else {
                image4 = nil
            }
        // -------------------------------------------------------------------------
	}
    
    // Depecrated
    enum ChangeType {
        //case NAME
        case DATA
        case IMAGE
    }
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(data, forKey: "data")
        
        if saveImages {
            /*
             Our Problem:
                 We only want to load the images up when the audit is opened, and we want to unload them
                 when the audit is closed. Once the audit is opened, we don't want to have to load them
                 again.
             
             Our Solution:
             (1)
                 Have a single static variable of AuditImagesModel that will be set when a single audit
                 is loaded. That way the old audit images will be unloaded when another audit is loaded.
                 This will be nil until an audit is loaded for the first time the app is run.
             
             Any other solutions?
             
             
             */
            
            aCoder.encode(image1Id, forKey: ("image1Id"))
            aCoder.encode(image2Id, forKey: ("image2Id"))
            aCoder.encode(image3Id, forKey: ("image3Id"))
            aCoder.encode(image4Id, forKey: ("image4Id"))
        }
    }
}
