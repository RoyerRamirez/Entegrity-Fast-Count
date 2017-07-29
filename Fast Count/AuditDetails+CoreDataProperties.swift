//
//  AuditDetails+CoreDataProperties.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import CoreData


extension AuditDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuditDetails> {
        return NSFetchRequest<AuditDetails>(entityName: "AuditDetails");
    }

    @NSManaged public var serves: String?
    @NSManaged public var id: String?
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var serial: String?
    @NSManaged public var year: String?
    @NSManaged public var voltage: String?
    @NSManaged public var phase: String?
    @NSManaged public var condition: String?
    @NSManaged public var discription: String?
    @NSManaged public var auditor: String?
    @NSManaged public var efficiency: String?
    @NSManaged public var notes: String?
    @NSManaged public var roomLocations: Location?

}
