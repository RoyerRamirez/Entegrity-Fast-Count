//
//  LocationsModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class LocationModel: NSObject, NSCoding {

    var name : String
    var data : [String:String] // Dictioary
    
    override var description: String {
        get {
            return self.name
        }
    }
    
    init(withName name:String) {
        self.name = name
        data = [:]
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
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(data, forKey: "data")
    }
    
}

