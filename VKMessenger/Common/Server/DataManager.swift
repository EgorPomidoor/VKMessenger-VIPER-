//
//  DataLayer.swift
//  VKMessenger
//
//  Created by Егор on 19.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class DataManager {
    
    class func getDialogs (count: Int , offset: Int, success: @escaping () -> Void, failure: @escaping (Int) -> Void ) {
       
        let operation = GetChatOperation(count: count, offset: offset, success: success, failure: failure)
        OperationsManager.addOperationToFirstQueue(operation: operation, cancellingQueue: true)
    }
    
    class func getDetailChat(idForRequest: Int64, chatID: Int64, count: Int, offset: Int, success: @escaping (NSArray) -> Void, failure: @escaping (Int) -> Void) {
        let operation = GetDetailChatOperation(count: count, offset: offset, idForRequest: idForRequest, chatID: chatID, success: success, failure: failure)
        OperationsManager.addOperationToFirstQueue(operation: operation, cancellingQueue: true)
    }
    
    class func sendMessage(id: Int64, randomId: Int, message: String, success: @escaping () -> Void, failure: @escaping (Int) -> Void) {
        let operation = SendMessageOperation(id: id, randomId: randomId, message: message, success: success, failure: failure)
        OperationsManager.addOperationToSecondQueue(operation: operation, cancellingQueue: true)
    }
}
