//
//  UserFabrique.swift
//  VKMessenger
//
//  Created by Егор on 19.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData

class CoreDataUserFabric {
    
    class func setUser (id: Int64, name: String, avatarURL: String, context: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [User]
        
        if fetchResults!.count == 0 {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            
            user.id = id
            user.name = name
            user.avatarURL = avatarURL
        } else {
            let user = fetchResults![0]
            
            user.name = name
            user.avatarURL = avatarURL
        }
    }
    
    
    
    class func getUser (id: Int64, contex: NSManagedObjectContext) -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? contex.fetch(fetchRequest) as! [User]
        
        return fetchResults!.count == 0 ? nil: fetchResults![0]
    }
}
