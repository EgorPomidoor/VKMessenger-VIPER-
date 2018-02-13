//
//  ChatFabrique.swift
//  VKMessenger
//
//  Created by Егор on 20.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData
class CoreDataChatFabric {
    
    class func setChat (id: Int64, senderID: Int64, out: Int64, snippet: String, timestamp: Int64, title: String, type: String, userIDs: String, chatID: Int64, multichatPhoto: String, context: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Chat]
        
        if fetchResults!.count == 0 {
            let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as! Chat
            
            chat.id = id
            chat.senderID = senderID
            chat.snippet = snippet
            chat.timestamp = timestamp
            chat.title = title
            chat.type = type
            chat.userIDs = userIDs
            chat.multichatPhoto = multichatPhoto
            chat.out = out
            chat.chatID = chatID
        } else {
            let chat = fetchResults![0]
            
            chat.senderID = senderID
            chat.snippet = snippet
            chat.timestamp = timestamp
            chat.title = title
            chat.type = type
            chat.userIDs = userIDs
            chat.multichatPhoto = multichatPhoto
            chat.out = out
            chat.chatID = chatID
        }
    }
    
    
    class func getChat (id: Int64, contex: NSManagedObjectContext) -> Chat? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? contex.fetch(fetchRequest) as! [Chat]
        
        return fetchResults!.count == 0 ? nil: fetchResults![0]
    }
    
    class func addMessages(id: Int64, set: NSMutableSet) {
        
    }
}
