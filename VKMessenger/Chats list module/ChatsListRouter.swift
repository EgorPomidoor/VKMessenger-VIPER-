//
//  ChatsListRouter.swift
//  VKMessenger
//
//  Created by Егор on 05.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class ChatsListRouter: ChatsListRouterInterface {
    
    private let storyboard = UIStoryboard(name: "ChatsList", bundle: nil)
    weak var rootModuleController: UIViewController?
    
    func showDetails(id: Int64) {
        //роутеру должны передать айдишник (setUpModule в интерактор закинет айдишник, то есть надо, чтобы у DetailChatRouter() метод setUpModule в свои аргументы принимал отсюда id)
        let router = DetailChatRouter()
        
        rootModuleController?.navigationController?.pushViewController(router.setUpModule(id: id), animated: true)
    }
    
    func setUpModule(from viewController: UIViewController) {
        
    }
    
    func setUpModule() -> UIViewController {
        
        let initialController = storyboard.instantiateViewController(withIdentifier: "chatsListVC") as! ChatsListViewController
        let presenter = ChatsListPresenter()
        let interactor = ChatsListInteractor()
        
        initialController.presenter = presenter
        initialController.router = self
        
        presenter.output = initialController
        presenter.interactot = interactor
        
        interactor.output = presenter
        
        rootModuleController = initialController
        return initialController
    }
}
