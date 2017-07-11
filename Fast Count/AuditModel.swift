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
    var categories : [CategoryModel]
    var locations : [LocationModel]
    
    // Retreving the name associated with the string
    override var description: String {
        get {
            return self.name
        }
    }
    
    init(withName name : String) {
        self.name = name
        self.categories = []
        self.locations = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            name = ""
        }
        
        if let categories = aDecoder.decodeObject(forKey: "categories") as? [CategoryModel] {
            self.categories = categories
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
        aCoder.encode(name, forKey: "name")
        aCoder.encode(categories, forKey: "categories")
        aCoder.encode(locations, forKey: "locations")
    }
	
    class func loadAuditsFromUserDefaults() {
        if let data = UserDefaults.standard.object(forKey: "audits") as? Data{
            self.audits = NSKeyedUnarchiver.unarchiveObject(with: data) as! [AuditModel]
        } else {
            print("Unable to retrieve audits")
            audits = []
        }
    }
    
    class func saveAuditsToUserDefaults(){
        let data = NSKeyedArchiver.archivedData(withRootObject: audits)
        UserDefaults.standard.set(data, forKey: "audits")
    }

}
