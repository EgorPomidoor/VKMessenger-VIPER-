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
    func success(arrayOfMOdels: NSMutableArray)
    func failure(code: Int)
}

protocol DetailChatRouterInterface: class {
    func setUpModule(id: Int64) -> UIViewController
}
