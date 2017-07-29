//
//  Location+CoreDataProperties.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var locationName: String?
    @NSManaged public var categories: Category?
    @NSManaged public var auditDetails: NSSet?

}

// MARK: Generated accessors for auditDetails
extension Location {

    @objc(addAuditDetailsObject:)
    @NSManaged public func addToAuditDetails(_ value: AuditDetails)

    @objc(removeAuditDetailsObject:)
    @NSManaged public func removeFromAuditDetails(_ value: AuditDetails)

    @objc(addAuditDetails:)
    @NSManaged public func addToAuditDetails(_ values: NSSet)

    @objc(removeAuditDetails:)
    @NSManaged public func removeFromAuditDetails(_ values: NSSet)

}
