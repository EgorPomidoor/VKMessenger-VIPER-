//
//  OperationsManager.swift
//  VKMessenger
//
//  Created by Егор on 23.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class OperationsManager {
    
    private static let operationQueue = OperationQueue()
    
    class func addOperation (operation: Operation, cancellingQueue: Bool ) {
        
        if cancellingQueue {
            operationQueue.cancelAllOperations()
        }
        
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperation(operation)
    }
}
