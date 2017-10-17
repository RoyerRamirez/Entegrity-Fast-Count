//
//  AuditModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class AuditModel: NSObject, NSCoding {
	
	// "static" does the same thing as when you put "class" in front of a function. It is accessible
	// from other classes without having to create a new instance of it. The array below can be 
	// accessed by "AuditModel.audits". We can then modify our save and load methods to read/write
	// to this list, and when our ExistingAuditViewController loads the list up, it'll reference 
	// this list rather than one that it has. 
	static var audits : [AuditModel] = []

    var name : String
    var uid : Int // unique Job Number
    var categories : [CategoryModel]
    var locations : [LocationModel]
    
    // Set to true before saving if changes made were to images
    var saveImages: Bool = false
    
    // Retreving the name associated with the string
    override var description: String {
        get {
            return self.name
        }
    }
    
    init(withName name : String, uid : Int) {
        self.name = name
        self.uid = uid
        self.categories = []
        self.locations = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            name = ""
        }
        
        self.uid = aDecoder.decodeInteger(forKey: "uid")
        
        if let categories = aDecoder.decodeObject(forKey: "categories") as? [CategoryModel] {
            self.categories = categories
			for category in categories {
				for location in category.locations {
					location.parentCategory = category
				}
			}
            
        } else {
            categories = []
        }
        if let locations = aDecoder.decodeObject(forKey: "locations") as? [LocationModel] {
            self.locations = locations
        } else {
            locations = []
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.categories, forKey: "categories")
        aCoder.encode(self.locations, forKey: "locations")
       
    }
    // the two functions below are added for convinence:
        // To save an audit, simply call audit.save()
    func save(){
        AuditFilesManager.saveAudit(audit: self , uid: self.uid)
    }
    
    func saveWithImages(){
        self.saveImages = true
        AuditFilesManager.saveAudit(audit: self , uid: self.uid)
        self.saveImages = false
        
        if AuditImagesModel.currentAuditImages != nil {
            AuditFilesManager.saveAuditImages(auditImages: AuditImagesModel.currentAuditImages!, uid: self.uid)
        }
    }
        // To delete an Audit, call audit.delete()
    func delete(){
        AuditFilesManager.deleteAudit(uid: self.uid)
    }
}
