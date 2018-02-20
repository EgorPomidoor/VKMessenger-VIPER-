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
//    let modelsArray = NSMutableArray()
    var chatID: Int64?
    
    func getData(offset: Int) {
        CoreDataManager.sharedInstance.save()
        
        DataManager.getDetailChat(idForRequest: idForRequest!, chatID: chatID!, count: 20, offset: offset, success: { (array) in
            
//            for id in array {
//                let coreDataModel = CoreDataDetailChatFabric.getDetailChat(id: id as! Int64, context: CoreDataManager.sharedInstance.getMainContext())
//                let usualModel = DetailChatModel(id: (coreDataModel?.id)!, userID: (coreDataModel?.userID)!, fromID: (coreDataModel?.fromID)!, body: (coreDataModel?.body)!, date: (coreDataModel?.date)!, out: (coreDataModel?.out)!, readState: (coreDataModel?.readState)!)
//                self.modelsArray.add(usualModel)
//            }
            
            self.output?.success(idForFRC: self.chatID!)
        }, failure: {(error) in
            
            self.output?.failure(code: error)
            
        })
    }
}
