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
	
    // Make the new image structure compatible with the old system by using computed fields.
    // These variables aren't ever storing anything; they're just running other code when location.image1 is set or gotten.
    var image1 : UIImage? {
        get {
            return AuditImagesModel.currentAuditImages?.getImage(id: image1Id)
        }
        set(newValue) {
            if let id = AuditImagesModel.currentAuditImages?.saveImage(id: image1Id, image: newValue) {
                image1Id = id
            }
            
        }
    }
    
    var image2 : UIImage? {
        get {
            return AuditImagesModel.currentAuditImages?.getImage(id: image2Id)
        }
        set(newValue) {
            if let id = AuditImagesModel.currentAuditImages?.saveImage(id: image2Id, image: newValue) {
                image2Id = id
            }
        }
    }
    
    var image3 : UIImage? {
        get {
            return AuditImagesModel.currentAuditImages?.getImage(id: image3Id)
        }
        set(newValue) {
            if let id = AuditImagesModel.currentAuditImages?.saveImage(id: image3Id, image: newValue) {
                image3Id = id
            }
        }
    }
    var image4 : UIImage? {
        get {
            return AuditImagesModel.currentAuditImages?.getImage(id: image4Id)
        }
        set(newValue) {
            if let id = AuditImagesModel.currentAuditImages?.saveImage(id: image4Id, image: newValue) {
                image4Id = id
            }
        }
    }
    
    var image1Id : Int?
    var image2Id : Int?
    var image3Id : Int?
    var image4Id : Int?
	
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
        
        // Support for old versions of the app
        if let image = aDecoder.decodeObject(forKey: "image1") as? UIImage {
            print("Found an image saved in the audit file")
            self.image1Id = AuditImagesModel.currentAuditImages?.saveImage(id: nil, image: image)!
        }
        
        if let image = aDecoder.decodeObject(forKey: "image2") as? UIImage {
            print("Found an image saved in the audit file")
            self.image1Id = AuditImagesModel.currentAuditImages?.saveImage(id: nil, image: image)!
        }
        
        if let image = aDecoder.decodeObject(forKey: "image3") as? UIImage {
            print("Found an image saved in the audit file")
            self.image1Id = AuditImagesModel.currentAuditImages?.saveImage(id: nil, image: image)!
        }
        
        if let image = aDecoder.decodeObject(forKey: "image4") as? UIImage {
            print("Found an image saved in the audit file")
            self.image1Id = AuditImagesModel.currentAuditImages?.saveImage(id: nil, image: image)!
        }

        // Image IDs
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
	}
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(data, forKey: "data")
        
        if parentCategory?.parentAudit?.saveImages != nil && parentCategory!.parentAudit!.saveImages {
            if image1Id != nil {
                aCoder.encode(image1Id, forKey: ("image1Id"))
            }
            
            if image2Id != nil {
                aCoder.encode(image2Id, forKey: ("image2Id"))
            }
            
            if image3Id != nil {
                aCoder.encode(image3Id, forKey: ("image3Id"))
            }
            
            if image4Id != nil {
                aCoder.encode(image4Id, forKey: ("image4Id"))
            }
        }
        
    }
}
