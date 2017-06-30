//
//  AuditModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class AuditModel: NSObject, NSCoding {
    var name : String
    var categories : [CategoryModel]
    
    // Retreving the name associated with the string
    override var description: String {
        get {
            return self.name
        }
    }
    
    init(withName name : String) {
        self.name = name
        self.categories = []
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
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(categories, forKey: "categories")
    }
    
    class func getAuditsFromUserDefaults() -> [AuditModel] {
        if let data = UserDefaults.standard.object(forKey: "audits") as? Data{
            return NSKeyedUnarchiver.unarchiveObject(with: data) as! [AuditModel]
        } else {
            print("Unable to retrieve audits")
            return []
        }
    }
    
    class func saveAuditsToUserDefaults(_ audits: [AuditModel]){
        let data = NSKeyedArchiver.archivedData(withRootObject: audits)
        UserDefaults.standard.set(data, forKey: "audits")
    }
}
