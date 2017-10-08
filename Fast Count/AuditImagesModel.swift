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
    static var auditImages: AuditImagesModel!
    
    // keys, int --> unique identifier, value --> UIImage
    var images: [Int:UIImage] = [:];

    func encode(with aCoder: NSCoder) {
        aCoder.encode(images, forKey: "images")
    }
    
    required init?(coder aDecoder: NSCoder) {
        images = aDecoder.decodeObject(forKey: "images") as! Dictionary
    }
    
    func getImage(id: Int) -> UIImage? {
        return images[id]
    }

    func saveImage(id: Int?, image: UIImage) {
        if let theID = id {
            images[theID] = image
        } else {
            images[images.keys.count] = image
        }
        
        // save file
    }
}
