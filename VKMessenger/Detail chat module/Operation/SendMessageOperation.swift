//
//  SendMessageOperation.swift
//  VKMessenger
//
//  Created by Егор on 22.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation
import CoreData

class SendMessageOperation: Operation {
    
    var success: () -> Void
    var failure: (Int) -> Void
    var id: Int64
    var randomId: Int
    var message: String
    
    var urlSessionDataTask: URLSessionDataTask?
    
    init (id: Int64, randomId: Int, message: String, success: @escaping () -> Void, failure: @escaping (Int) -> Void) {
        self.success = success
        self.failure = failure
        self.id = id
        self.randomId = randomId
        self.message = message
        
        super.init()
    }
    
   override func cancel() {
        urlSessionDataTask?.cancel()
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        let backgroundContext = CoreDataManager.sharedInstance.getBackgroundContext()
        let set = NSMutableSet()
        let encodeMessage = message.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        
        API_WRAPPER.sendMessage(id: id, randomId: randomId, message: encodeMessage!, success: { (response) in
            let messageId = response["response"].int64Value
            
            CoreDataDetailChatFabric.setDetailChat(id: messageId, userID: 0, fromID: 0, body: self.message, date: 0, out: 0, readState: 0, context: backgroundContext)
            let message = CoreDataDetailChatFabric.getDetailChat(id: messageId, context: backgroundContext)
            set.add(message)
            
            CoreDataChatFabric.addMessagesToChat(chatID: self.id, messagesSet: set, context: backgroundContext)
           _ = try? backgroundContext.save()
            self.success()
            semaphore.signal()
        }, failure: {(error) in
            self.failure(error)
            semaphore.signal()
        })
        
       _ = semaphore.wait(timeout: .distantFuture)
    }
    
}
