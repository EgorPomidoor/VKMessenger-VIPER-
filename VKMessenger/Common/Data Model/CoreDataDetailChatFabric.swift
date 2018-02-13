//
//  CoreDataDetailChatFabric.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData


class CoreDataDetailChatFabric {
    
    class func setDetailChat (id: Int64, userID: Int64, fromID: Int64, body: String, date: Int64, out: Int64, readState: Int64, context: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailChat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [DetailChat]
        
        if fetchResults!.count == 0 {
            let detailChat = NSEntityDescription.insertNewObject(forEntityName: "DetailChat", into: context) as! DetailChat
            
            detailChat.id = id
            detailChat.userID = userID
            detailChat.fromID = fromID
            detailChat.body = body
            detailChat.date = date
            detailChat.out = out
            detailChat.readState = readState
            
        } else {
            let detailChat = fetchResults![0]
            
            detailChat.userID = userID
            detailChat.fromID = fromID
            detailChat.body = body
            detailChat.date = date
            detailChat.out = out
            detailChat.readState = readState

        }
    }
    
    class func getDetailChat (id: Int64, context: NSManagedObjectContext) -> DetailChat?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailChat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [DetailChat]
        
        return fetchResults!.count == 0 ? nil: fetchResults![0]
    }
}
