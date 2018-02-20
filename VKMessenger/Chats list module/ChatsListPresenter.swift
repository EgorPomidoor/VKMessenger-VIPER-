//
//  ChatsListPresenter.swift
//  VKMessenger
//
//  Created by Егор on 05.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import CoreData

class ChatsListPresenter: NSObject, ChatsListPresenterInput {
    
    weak var output: ChatsListPresenterOutput?
    var interactot: ChatsListInteractorInput?
    lazy var fetchedResultController : NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedInstance.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        _ = try? frc.performFetch()
        
        return frc
    }()
    
    func getData(offset: Int) {
        interactot?.getData(offset: offset)
    }
    
    func numberOfEntities() -> Int {
        
        if let objectsArray = fetchedResultController.fetchedObjects{
            return objectsArray.count
        }
        
        return 0
    }
    
    func entityAt(indexPath: IndexPath) -> Any? {
        return fetchedResultController.object(at: indexPath)
    }
    
}

//MARK:- протокол NSFetchedResultsControllerDelegate
extension ChatsListPresenter: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.output?.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        DispatchQueue.main.async {
            switch type {
            case .insert:
                self.output?.insert(at: newIndexPath!)
            case .update:
                self.output?.update(at: indexPath!)
            case .move:
                self.output?.move(at: indexPath!, to: newIndexPath!)
            case .delete:
                self.output?.delete(at: indexPath!)
            default:
                return
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.output?.endUpdates()
        }
    }
}

//MARK:- протокол ChatsListInteractorOutput
extension ChatsListPresenter: ChatsListInteractorOutput {
    func success() {
        CoreDataManager.sharedInstance.save()
        DispatchQueue.main.async {
            self.output?.endRefreshing()
        }
    }
    
    func failure(code: Int) {
        print("код ошибки: \(code)")
        DispatchQueue.main.async {
            self.output?.endRefreshing()
        }
    }
}
