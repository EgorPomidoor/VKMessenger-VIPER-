//
//  DetailChatPresenter.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import Foundation
import CoreData

class DetailChatPresenter: NSObject {
    
    weak var output: DetailChatPresenterOutput?
    var interactor: DetailChatInteractorInput?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var idForFRC: Int64 //это айди чата/мультичата с первого VC (класс Chat)
    var dialogIsEmpty = true
    
    init (idForFRC: Int64) {
        self.idForFRC = idForFRC
    }
    
    func setUpFRC() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DetailChat")
        let predicate = NSPredicate(format: "mainDialog.id=%lld", idForFRC )
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        _ = try? frc.performFetch()
        fetchedResultsController = frc
    }
}


//MARK:- протокол DetailChatPresenterInput
extension DetailChatPresenter: DetailChatPresenterInput {
    
    func getData(offset: Int) {
        
        if CoreDataChatFabric.hasMessages(chatID: idForFRC, context: CoreDataManager.sharedInstance.getMainContext()) {
            dialogIsEmpty = false
            setUpFRC()
            output!.reloadData()
        }
        
        interactor?.getData(offset: offset)
    }
    
    func sendMessage(message: String) {
        let randomNumber = Int(arc4random())
        interactor?.sendMessage(id: idForFRC, randomId: randomNumber, message: message)
    }
    
    func numberOfEntities() -> Int {
        if fetchedResultsController == nil {
            return 0
        } else {
            return fetchedResultsController!.fetchedObjects!.count
        }
    }
    
    func entityAt(indexPath: IndexPath) -> Any? {
        if fetchedResultsController == nil {
            return nil
        } else {
            return fetchedResultsController!.object(at: indexPath)
        }
    }
    
}


//MARK:- протокол DetailChatInteractorOutput
extension DetailChatPresenter: DetailChatInteractorOutput {
    
    func success(idForFRC id: Int64) {
        //self.idForFRC = id
        
        if dialogIsEmpty {
            setUpFRC()
            self.output?.reloadData()
            dialogIsEmpty = false
        }
        
        output?.scroll(indexPath: IndexPath(row: (fetchedResultsController?.fetchedObjects?.count)! - 1, section: 0))
    }
    
    func failure(code: Int) {
        print("код ошибки: \(code)")
    }
    
    func messageHasSentSuccessfully() {
        output?.scroll(indexPath: IndexPath(row: (fetchedResultsController?.fetchedObjects?.count)! - 1, section: 0))
    }
}

//MARK:- протокол NSFetchedResultsControllerDelegate
extension DetailChatPresenter: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        output?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            output?.insert(at: newIndexPath!)
            output?.scroll(indexPath: IndexPath(row: (fetchedResultsController?.fetchedObjects?.count)! - 1, section: 0))
        case .update:
            output?.update(at: indexPath!)
        case .move:
            output?.move(at: indexPath!, to: newIndexPath!)
        case .delete:
            output?.delete(at: indexPath!)
        default:
            return
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        output?.endUpdates()
    }
    
}
