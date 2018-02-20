//
//  GetDetailChatOperation.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation
import CoreData

class GetDetailChatOperation: Operation {
    
    var success: (NSMutableArray) -> Void
    var failure: (Int) -> Void
    var count: Int
    var offset: Int
    var idForRequest: Int64
    var chatID: Int64
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init (count: Int, offset: Int, idForRequest: Int64, chatID: Int64, success:@escaping (NSMutableArray) -> Void, failure:@escaping (Int) -> Void) {
        self.count = count
        self.offset = offset
        self.idForRequest = idForRequest
        self.success = success
        self.failure = failure
        self.chatID = chatID
        
        super.init()
    }
    
    override func cancel() {
        urlSessionDataTask?.cancel()
    }
    
    
    override func main() {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let arrayWithIDs = NSMutableArray() // не нужен (так как убрали обычные модели)
        let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
        
        API_WRAPPER.getDetailChat(id: idForRequest, count: count, offset: offset, success: { (response) in
            
            let items = response["response"]["items"].arrayValue
            let set = NSMutableSet()
                        
            for item in items {
                let id = item["id"].int64Value
                let userID = item["user_id"].int64Value
                let fromID = item["from_id"].int64Value
                let body = item["body"].stringValue
                let date = item["date"].int64Value
                let out = item["out"].int64Value
                let readState = item["read_state"].int64Value
                
                CoreDataDetailChatFabric.setDetailChat(id: id, userID: userID, fromID: fromID, body: body, date: date, out: out, readState: readState, context: backgroundContext)
                arrayWithIDs.add(id)
                
                let message = CoreDataDetailChatFabric.getDetailChat(id: id, context: backgroundContext)
                set.add(message)
            }
            
            
            if self.isCancelled {
                self.success(arrayWithIDs)
            } else {
                
                CoreDataChatFabric.addMessagesToChat(chatID: self.chatID, messagesSet: set, context: backgroundContext)
                
                _ = try? backgroundContext.save()
                self.success(arrayWithIDs)
            }
            
            _ = semaphore.signal()
            
        }, failure: {(errorCode) in
            
            self.failure(errorCode)
            _ = semaphore.signal()

        })
        
        _ = semaphore.wait(timeout: .distantFuture)
    }
}
