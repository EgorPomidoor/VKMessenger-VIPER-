//
//  CoreDataManager.swift
//  VKMessenger
//
//  Created by Егор on 19.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
       let modelURL = Bundle.main.url(forResource: "Messenger", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        objc_sync_enter(self)
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent("Messenger.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
        }
        
        objc_sync_exit(self)
        
        return coordinator
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func getMainContext () -> NSManagedObjectContext {
        return managedObjectContext
    }
    
    func getBackgroundContext () -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }
    
    func save () {
        _ = try? managedObjectContext.save()
    }
}
