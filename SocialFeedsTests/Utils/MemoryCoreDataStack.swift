//
//  MemoryCoreDataStack.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 25/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import CoreData
@testable import SocialFeeds

class MemoryCoreDataStack: CoreDataStack {
    
    lazy override var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SocialFeeds")
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    override func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
