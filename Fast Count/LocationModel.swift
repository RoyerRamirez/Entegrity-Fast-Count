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
        //if aDecoder.containsValue(forKey: "image1")
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

        
        
        
	}
    
    enum ChangeType {
        //case NAME
        case DATA
        case IMAGE
    }
   
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(data, forKey: "data")
        if lastChange == nil {
            return
        }
        
        switch lastChange! {
        case .DATA:
            aCoder.encode(name, forKey: "name")
            aCoder.encode(data, forKey: "data")
        default:
            if let image = image1   {
                aCoder.encode(image, forKey: "image1")
            }
            if let image = image2 {
                aCoder.encode(image, forKey: "image2")
            }
            if let image = image3 {
                aCoder.encode(image, forKey: "image3")
            }
            if let image = image4 {
                aCoder.encode(image, forKey: "image4")
            }
        }
        
        
    }
    
}



