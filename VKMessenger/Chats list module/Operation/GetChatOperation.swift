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
                let timestamp = message["date"].int64Value
                let out = message["out"].int64Value
                let userID = message["user_id"].int64Value
                let title = message["title"].stringValue
                let readState = message["read_state"].int64Value
                var snippet = message["body"].stringValue
                
                if snippet == "" {
                    let fwdMessages = message["fwdMessages"].arrayValue
                    let attachment = message["attachments"].arrayValue
                    var tempBody = ""
                    
                    for attach in attachment {
                        let type = attach["type"].stringValue
                        
                        switch type {
                        case "photo" :
                            tempBody = "Фотография"
                        case "video":
                            tempBody = "Видеозапись"
                        case "audio":
                            tempBody = "Аудиозапись"
                        case "doc":
                            tempBody = "Документ"
                        case "link":
                            tempBody = "Ссылка"
                        case "market":
                            tempBody = "Товар"
                        case "market_album":
                            tempBody = "Подборка товаров"
                        case "wall":
                            tempBody = "Запись на стене"
                        case "wall_reply":
                            tempBody = "Комментарий на стене"
                        case "sticker":
                            tempBody = "Стикер"
                        case "gift":
                            tempBody = "Подарок"
                        default:
                            return
                        }
                        
                        
                        if snippet == "" {
                            snippet = tempBody
                        } else {
                            snippet = snippet + ", " + tempBody
                        }
                    }
                    
                    if message["fwd_messages"] != nil {
                        snippet = "Пересланное сообщение"
                    }
                }
                
                if message["photo_100"] != nil {
                    multichatPhoto = message["photo_100"].stringValue
                }
                
                if message["chat_id"] != nil {
                    
                    let type = "Multichat"
                    let users = message["chat_active"].arrayValue
                    chatID = message["chat_id"].int64Value
                    
                    for user in users {
                        stringForGetUsers += "\(user.stringValue),"
                    }
                    
                    CoreDataChatFabric.setChat(id: chatID, userID: userID, out: out, snippet: snippet, timestamp: timestamp, title: title, type: type, chatID: chatID, multichatPhoto: multichatPhoto, readState: readState, context: backgroundContex)
                    let chat = CoreDataChatFabric.getChat(id: chatID, contex: backgroundContex)
                    
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
                    
                } else {
                    
                    let type = "Dialogue"
                    stringForGetUsers += "\(userID),"
                    
                    CoreDataChatFabric.setChat(id: userID, userID: userID, out: out, snippet: snippet, timestamp: timestamp, title: title, type: type, chatID: chatID, multichatPhoto: multichatPhoto, readState: readState, context: backgroundContex)
                    let chat = CoreDataChatFabric.getChat(id: userID, contex: backgroundContex)
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
            }
            _ = try? backgroundContext.save()
            semaphore.signal()
            
        }, failure: {kek in})
        
    }
    
}


