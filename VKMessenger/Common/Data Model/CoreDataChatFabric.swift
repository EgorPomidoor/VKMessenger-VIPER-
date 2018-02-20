//
//  ChatFabrique.swift
//  VKMessenger
//
//  Created by Егор on 20.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData
class CoreDataChatFabric {
    
    class func setChat (id: Int64, userID: Int64, out: Int64, snippet: String, timestamp: Int64, title: String, type: String, chatID: Int64, multichatPhoto: String, readState: Int64, context: NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Chat]
        
        if fetchResults!.count == 0 {
            let chat = NSEntityDescription.insertNewObject(forEntityName: "Chat", into: context) as! Chat
            
            chat.id = id
            chat.userID = userID
            chat.snippet = snippet
            chat.timestamp = timestamp
            chat.title = title
            chat.type = type
            chat.multichatPhoto = multichatPhoto
            chat.out = out
            chat.chatID = chatID
            chat.readState = readState
        } else {
            let chat = fetchResults![0]
            
            chat.userID = userID
            chat.snippet = snippet
            chat.timestamp = timestamp
            chat.title = title
            chat.type = type
            chat.multichatPhoto = multichatPhoto
            chat.out = out
            chat.chatID = chatID
            chat.readState = readState
        }
    }
    
    
    class func getChat (id: Int64, contex: NSManagedObjectContext) -> Chat? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? contex.fetch(fetchRequest) as! [Chat]
        
        return fetchResults!.count == 0 ? nil : fetchResults![0]
    }
    
    
    class func addMessagesToChat (chatID id: Int64, messagesSet set: NSMutableSet, context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let predicate = NSPredicate(format: "id=%lld", id)
        fetchRequest.predicate = predicate
        
        let fetchResults = try? context.fetch(fetchRequest) as! [Chat]
        
        let chat = fetchResults![0]
        chat.addToMessages(set)
    }
    
    class func hasMessages (chatID: Int64, context: NSManagedObjectContext) -> Bool {
        
        let chat = getChat(id: chatID, contex: context)
        
        if chat != nil {
            if chat!.messages != nil {
                return chat!.messages!.allObjects.count != 0
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
