//
//  DatabaseController.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 7/26/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {
    
    private init(){
        
    }
    
    class func getContext() -> NSManagedObjectContext{
        return DatabaseController.persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Uresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // Core Data saving support
    class func saveContext (){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Uresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
