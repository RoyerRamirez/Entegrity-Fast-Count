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
            return parentCategory!.parentAudit!.images.getImage(id: image1Id)
        }
        set(newValue) {
            if let id = parentCategory!.parentAudit!.images.saveImage(id: image1Id, image: newValue) {
                image1Id = id
            }
            
        }
    }
    
    var image2 : UIImage? {
        get {
            return parentCategory!.parentAudit!.images.getImage(id: image2Id)
        }
        set(newValue) {
            if let id = parentCategory!.parentAudit!.images.saveImage(id: image2Id, image: newValue) {
                image2Id = id
            }
        }
    }
    
    var image3 : UIImage? {
        get {
            return parentCategory!.parentAudit!.images.getImage(id: image3Id)
        }
        set(newValue) {
            if let id = parentCategory!.parentAudit!.images.saveImage(id: image3Id, image: newValue) {
                image3Id = id
            }
        }
    }
    var image4 : UIImage? {
        get {
            return parentCategory!.parentAudit!.images.getImage(id: image4Id)
        }
        set(newValue) {
            if let id = parentCategory!.parentAudit!.images.saveImage(id: image4Id, image: newValue) {
                image4Id = id
            }
        }
    }
    
    // forward compatibility
    var image1tmp : UIImage?
    var image2tmp : UIImage?
    var image3tmp : UIImage?
    var image4tmp : UIImage?
    
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
            self.image1tmp = image
        }
        
        if let image = aDecoder.decodeObject(forKey: "image2") as? UIImage {
            print("Found an image saved in the audit file")
            self.image2tmp = image
        }
        
        if let image = aDecoder.decodeObject(forKey: "image3") as? UIImage {
            print("Found an image saved in the audit file")
            self.image3tmp = image
        }
        
        if let image = aDecoder.decodeObject(forKey: "image4") as? UIImage {
            print("Found an image saved in the audit file")
            self.image4tmp = image
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
    
    // run after self.parentCategory is set to ensure images of old file format are kept with new format
    func forwardCompatibleImages() {
        var saveAudit = false
        
        if let image = self.image1tmp {
            self.image1 = image
            self.image1tmp = nil
            saveAudit = true
        }
        
        if let image = self.image2tmp {
            self.image2 = image
            self.image2tmp = nil
            saveAudit = true
        }
        
        if let image = self.image3tmp {
            self.image3 = image
            self.image3tmp = nil
            saveAudit = true
        }
        
        if let image = self.image4tmp {
            self.image4 = image
            self.image4tmp = nil
            saveAudit = true
        }
        
        if saveAudit {
            parentCategory!.parentAudit!.saveWithImages()
        }
    }
}
