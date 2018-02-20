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
}

protocol DetailChatInteractorInput: class {
    func getData(offset: Int)
}

protocol DetailChatInteractorOutput: class {
    func success(idForFRC id: Int64)
    func failure(code: Int)
}

protocol DetailChatRouterInterface: class {
    func setUpModule(idForRequest: Int64, currentChatID: Int64) -> UIViewController
}
