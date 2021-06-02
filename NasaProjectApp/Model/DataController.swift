//
//  DataController.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // this helps avoid CoreData Errors:
//    var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        // must add something like this if using constraints in CoreDate (unique dateLabels) to avoid saving conflicts.  In this case, user will not be able to resave/overwrite an old photo unless the old photo is deleted first! :
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    
    
    func load(completion: (() -> Void)? = nil ) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            // now this is after the container has loaded the persistent store in this handler:
            self.autoSaveViewContext()
            completion?()
        }
    }
}

extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 30) {
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}

