//
//  ChatsListInterfaces.swift
//  VKMessenger
//
//  Created by Егор on 05.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

protocol ChatsListPresenterOutput: class {
    func beginUpdates () -> Void
    func endUpdates () -> Void
    func insert(at: IndexPath ) -> Void
    func delete(at: IndexPath ) -> Void
    func move(at: IndexPath , to : IndexPath ) -> Void
    func update(at: IndexPath ) -> Void
}

protocol ChatsListPresenterInput: class {
    func getData(offset: Int)
    func numberOfEntities() -> Int
    func entityAt(indexPath: IndexPath) -> Any?
}

protocol ChatsListInteractorOutput: class {
    func success()
    func failure(code: Int)
}

protocol ChatsListInteractorInput {
    func getData(offset: Int)
}

protocol ChatsListRouterInterface : class
{
    func showDetails(id : Int64 )
    func setUpModule(from viewController : UIViewController )
    func setUpModule() -> UIViewController
}
