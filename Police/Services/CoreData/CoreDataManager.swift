//
//  CoreDataManager.swift
//  Police
//
//  Created by Riccardo Scanavacca on 22/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private static var manager: CoreDataManager?
    
    public class func shared() -> CoreDataManager {
        
        if manager == nil {
            manager = CoreDataManager()
        }
        return manager!
    }
    
    public var container: NSPersistentContainer
    
    private init() {
        
        container = NSPersistentContainer(name: "Police")
        
        if AppStatus.isTesting {
            
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if AppStatus.isTesting {
                precondition(storeDescription.type == NSInMemoryStoreType)
            }
            
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        
        CoreDataManager.shared().container.performBackgroundTask(block)
    }
    
    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        
        block(CoreDataManager.shared().container.viewContext)
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func setInMemoryStoreType(container: NSPersistentContainer) {
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
    }
}
