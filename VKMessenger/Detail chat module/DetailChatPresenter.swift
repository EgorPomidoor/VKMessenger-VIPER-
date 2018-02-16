//
//  DetailChatPresenter.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation

class DetailChatPresenter: DetailChatPresenterInput {
    
    weak var output: DetailChatPresenterOutput?
    var interactor: DetailChatInteractorInput?
    
    var modelsArray = NSArray()
    
    func getData(offset: Int) {
        interactor?.getData(offset: offset)
    }
    
    func numberOfEntities() -> Int {
        return modelsArray.count
    }
    
    func entityAt(indexPath: IndexPath) -> Any? {
        
        let indexPath = (modelsArray.count - 1) - indexPath.row
        
        if modelsArray.count - 1 < indexPath {
            return nil
        } else {
            return modelsArray[indexPath]
        }
    }
}


//MARK:- протокол DetailChatInteractorOutput
extension DetailChatPresenter: DetailChatInteractorOutput {
    
    func success(arrayOfMOdels: NSMutableArray) {
        DispatchQueue.main.async {
            self.modelsArray = arrayOfMOdels
            self.output?.reloadData()
        }
    }
    
    func failure(code: Int) {
        print("код ошибки: \(code)")
    }
    
    
}
