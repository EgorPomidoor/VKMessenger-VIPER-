//
//  DetailChatRouter.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class DetailChatRouter: DetailChatRouterInterface {
    
    private let storyboard = UIStoryboard(name: "DetailChat", bundle: nil)
    
    func setUpModule(id: Int64) -> UIViewController {
        
        let initialController = storyboard.instantiateViewController(withIdentifier: "detailChatVC") as! DetailChatViewController
        let presenter = DetailChatPresenter()
        let interactor = DetailChatInteractor()
        interactor.idFromPreviousVC = id
        
        initialController.presenter = presenter
        
        presenter.output = initialController
        presenter.interactor = interactor
        
        interactor.output = presenter
        
        return initialController
        
    }

}
