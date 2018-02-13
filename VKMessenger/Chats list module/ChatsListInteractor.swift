//
//  ChatsListInteractor.swift
//  VKMessenger
//
//  Created by Егор on 05.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class ChatsListInteractor: ChatsListInteractorInput {
    
    weak var output: ChatsListInteractorOutput?
    
    func getData(offset: Int) {
        
        DataManager.getDialogs(count: 20, offset: offset, success: {
            self.output?.success()
        }, failure: { errorCode in
            self.output?.failure(code: errorCode)
        })
        
    }
    
}
