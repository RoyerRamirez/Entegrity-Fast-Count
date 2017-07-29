//
//  Audit+CoreDataProperties.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import CoreData


extension Audit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Audit> {
        return NSFetchRequest<Audit>(entityName: "Audit");
    }

    @NSManaged public var auditName: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension Audit {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
