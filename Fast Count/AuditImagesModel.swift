//
//  ImageModel.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 10/6/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import UIKit

class AuditImagesModel: NSObject, NSCoding {
    
    // keys, int --> unique identifier, value --> UIImage
    var images: [Int:UIImage] = [:];
    
    var uid: Int

    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
        aCoder.encode(uid, forKey: "uid")
    }
    
    required init?(coder aDecoder: NSCoder) {
        images = aDecoder.decodeObject(forKey: "images") as! Dictionary
        uid = aDecoder.decodeInteger(forKey: "uid")
    }
    
    required init(uid: Int) {
        self.uid = uid
    }
    
    func getImage(id: Int?) -> UIImage? {
        if let unwrapped = id {
            return images[unwrapped]
        }
        return nil
    }

    // Adds image to dictionary and if no id number is supplied, a new one will be created and returned.
    // Returns nil if no id is created.
    func saveImage(id: Int?, image: UIImage?) -> Int? {
        if let theID = id {
            if let imageUW = image {
                images[theID] = imageUW
            } else {
                images.removeValue(forKey: theID)
            }
        } else {
            if let imageUW = image {
                let newUID = generateNewUID()
                images[newUID] = imageUW
                return newUID
            }
        }
        
        return nil
    }
    
    func generateNewUID() -> Int {
        var takenUIDs = [Int]()
        var newUID : Int!
        var i = 0
        
        for uid in images.keys {
            takenUIDs.append(uid)
        }
        
        repeat {
            newUID = i
            i += 1
        } while takenUIDs.contains(newUID)
        
        return newUID
    }
}
