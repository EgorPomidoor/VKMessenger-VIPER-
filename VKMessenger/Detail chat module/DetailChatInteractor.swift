//
//  DetailChatInteractor.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class DetailChatInteractor: DetailChatInteractorInput {
    
    weak var output: DetailChatInteractorOutput?
    
    var idForRequest: Int64?
    var chatID: Int64?
    
    func getData(offset: Int) {

        DataManager.getDetailChat(idForRequest: idForRequest!, chatID: chatID!, count: 20, offset: offset, success: { (array) in
            
            CoreDataManager.sharedInstance.save()
            self.output?.success(idForFRC: self.chatID!)
            
        }, failure: {(error) in
            
            self.output?.failure(code: error)
            
        })
    }
    
    func sendMessage(id: Int64, randomId: Int, message: String) {
        
        DataManager.sendMessage(id: id, randomId: randomId, message: message, success: {
            CoreDataManager.sharedInstance.save()

            self.output?.messageHasSentSuccessfully()
        }) { (error) in
            print(error)
        }
    }
}
