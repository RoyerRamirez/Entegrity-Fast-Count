//
//  CategoryModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class CategoryModel: NSObject, NSCoding {

    var name : String
    var locations : [LocationModel]
    
    override var description: String {
        get {
            return self.name
        }
    }
    
    init(withName name : String) {
        self.name = name
        self.locations = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            self.name = name
        } else {
            name = ""
        }
        
        if let locations = aDecoder.decodeObject(forKey: "locations") as? [LocationModel] {
            self.locations = locations
        } else {
            locations = []
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(locations, forKey: "locations")
    }
}
