//
//  DetailChatInterfaces.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

protocol DetailChatPresenterOutput: class {
    func reloadData()
    func scroll(indexPath: IndexPath)
    
    func beginUpdates()
    func insert(at: IndexPath)
    func delete(at: IndexPath)
    func move(at: IndexPath, to: IndexPath)
    func update(at: IndexPath)
    func endUpdates()
}

protocol DetailChatPresenterInput: class {
    func getData(offset: Int)
    func numberOfEntities() -> Int
    func entityAt(indexPath: IndexPath) -> Any?
    func sendMessage(message: String)
}

protocol DetailChatInteractorInput: class {
    func getData(offset: Int)
    func sendMessage(id: Int64, randomId: Int, message: String)
}

protocol DetailChatInteractorOutput: class {
    func success(idForFRC id: Int64)
    func failure(code: Int)
    func messageHasSentSuccessfully()
}

protocol DetailChatRouterInterface: class {
    func setUpModule(idForRequest: Int64, currentChatID: Int64) -> UIViewController
}
