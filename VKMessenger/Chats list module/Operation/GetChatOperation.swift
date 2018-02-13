//
//  GetChatOperation.swift
//  VKMessenger
//
//  Created by Егор on 23.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation
import CoreData

class GetChatOperation: Operation {
    
    var success: () -> Void
    var failure: (Int) -> Void
    var count: Int
    var offset: Int
    
    var urlSessionDatatask: URLSessionDataTask?
    
    init (count: Int, offset: Int, success: @escaping () -> Void, failure: @escaping (Int) -> Void) {
        self.success = success
        self.failure = failure
        self.count = count
        self.offset = offset
        
        super.init()
    }
    
    
    override func cancel() {
        urlSessionDatatask?.cancel()
    }
    
    
    override func main() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        API_WRAPPER.getDialogs(count: self.count, offset: self.offset, success: { (response) in
            
            var stringForGetUsers = ""
            let backgroundContex = CoreDataManager.sharedInstance.getBackgroundContext()
            
            let dialogObjects = response["response"]["items"].arrayValue
            
            for dialog in dialogObjects {
                
                let message = dialog["message"]
                
                var chatID = Int64(000)
                var multichatPhoto = "empty"
                let ID = message["id"].int64Value
                let snippet = message["body"].stringValue
                let timestamp = message["date"].int64Value
                let out = message["out"].int64Value
                
                if message["photo_100"] != nil {
                    multichatPhoto = message["photo_100"].stringValue
                }
                
                var senderID = message["user_id"].int64Value
                let title = message["title"].stringValue
                
                
                if message["chat_id"] != nil {
                    var usersStringForChat = ""
                    
                    let type = "Multichat"
                    let users = message["chat_active"].arrayValue
                    chatID = message["chat_id"].int64Value
                    
                    for user in users {
                        stringForGetUsers += "\(user.stringValue),"
                        usersStringForChat += "\(user.stringValue),"
                    }
        
                    CoreDataChatFabric.setChat(id: ID, senderID: senderID, out: out, snippet: snippet, timestamp: timestamp, title: title, type: type, userIDs: usersStringForChat, chatID: chatID, multichatPhoto: multichatPhoto, context: backgroundContex)
                    let chat = CoreDataChatFabric.getChat(id: ID, contex: backgroundContex)
                    
                    let set = NSSet()

                    for user in users {
                        let userID = Int64(user.stringValue)!
                        CoreDataUserFabric.setUser(id: userID, name: "", avatarURL: "", context: backgroundContex)
                        let user = CoreDataUserFabric.getUser(id: userID, contex: backgroundContex)
                        //chat?.addToUsers(user!)
                        user?.addToChats(chat!)
                        set.adding(user)
                    }

                    chat?.addToUsers(set)
                    //проверка -------------------------------------------------------
                    let fuck = chat!.users?.allObjects as! [User]
                    //print(fuck.count)
                    for fr in fuck {
                        //print (fr.id,fr.name)
                    }
                    //-------------------------------------------------------------
                } else {
                    
                    var usersStringForChat = ""
                    
                    let type = "Dialogue"
                    stringForGetUsers += "\(senderID),"
                    usersStringForChat += "\(senderID),"
                    
                    let userID = senderID
                    
//                    if message["out"].int64Value == 1 {
//                        senderID = Int64(VKMAuthService.sharedInstance.getMyID())!
//                    }
                    
                    
                    CoreDataChatFabric.setChat(id: ID, senderID: senderID, out: out, snippet: snippet, timestamp: timestamp, title: title, type: type, userIDs: usersStringForChat, chatID: chatID, multichatPhoto: multichatPhoto, context: backgroundContex)
                    let chat = CoreDataChatFabric.getChat(id: ID, contex: backgroundContex)
                    CoreDataUserFabric.setUser(id: userID, name: "", avatarURL: "", context: backgroundContex)
                    let user = CoreDataUserFabric.getUser(id: userID, contex: backgroundContex)
                    chat?.addToUsers(user!)
                    user?.addToChats(chat!)
                }
            }
            
            if self.isCancelled {
                
                self.success()
                _ = semaphore.signal()
                
            } else {
                
            self.getUsers(idsString: stringForGetUsers, semaphore: semaphore, backgroundContext: backgroundContex)
            //print(usersString)
            self.success()
                
            }
            
        }, failure: { (error) in
            
            self.failure(error)
            _ = semaphore.signal()
            
        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    
    
    private  func getUsers (idsString: String, semaphore: DispatchSemaphore, backgroundContext: NSManagedObjectContext) {
        
        API_WRAPPER.getUser(id: idsString, success: { (response) in
            let users = response["response"].arrayValue
            
            for user in users
            {
                let name = user["first_name"].stringValue + " " + user["last_name"].stringValue
                let userId = user["id"].int64Value
                let avatarURL = user["photo_100"].stringValue
                
                CoreDataUserFabric.setUser(id: userId, name: name, avatarURL: avatarURL, context: backgroundContext)
//                let man = CoreDataUserFabric.getUser(id: userId, contex: backgroundContext)
//                print(man?.name)
            }
            _ = try? backgroundContext.save()
            semaphore.signal()
        }, failure: {kek in})
        
    }
    
}


