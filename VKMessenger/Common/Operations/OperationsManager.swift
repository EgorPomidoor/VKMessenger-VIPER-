//
//  OperationsManager.swift
//  VKMessenger
//
//  Created by Егор on 23.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class OperationsManager {
    
    private static let firstOperationQueue = OperationQueue()
    class func addOperationToFirstQueue (operation: Operation, cancellingQueue: Bool ) {
        
        if cancellingQueue {
            firstOperationQueue.cancelAllOperations()
        }
        
        firstOperationQueue.maxConcurrentOperationCount = 1
        firstOperationQueue.addOperation(operation)
    }
    
    
    private static let secondOperationQueue = OperationQueue()
    class func addOperationToSecondQueue (operation: Operation, cancellingQueue: Bool) {
        
        if cancellingQueue {
            secondOperationQueue.cancelAllOperations()
        }
        
        secondOperationQueue.maxConcurrentOperationCount = 1
        secondOperationQueue.addOperation(operation)
    }
}
