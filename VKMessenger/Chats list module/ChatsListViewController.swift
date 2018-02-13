//
//  ChatsListViewController.swift
//  VKMessenger
//
//  Created by Егор on 05.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class ChatsListViewController: UIViewController {
    
    var presenter: ChatsListPresenterInput?
    var router: ChatsListRouter?
    
    @IBOutlet weak var tableView: UITableView!
    let kVKMChatTableVIewCell = UINib(nibName: "VKMChatTableViewCell", bundle: nil)
    let kVKMChatTableVIewCellReuseIdentifier = "kVKMChatTableVIewCellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(kVKMChatTableVIewCell, forCellReuseIdentifier: kVKMChatTableVIewCellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        
        presenter?.getData(offset: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

//MARK:- протокол UITableViewDataSource, UITableViewDelegate
extension ChatsListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter != nil ? presenter!.numberOfEntities() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kVKMChatTableVIewCellReuseIdentifier, for: indexPath) as! VKMChatTableViewCell
        
        if let model = presenter!.entityAt(indexPath: indexPath) as? Chat {
            cell.configureSelf(model: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let i = presenter!.numberOfEntities()
        let lastItem = presenter!.numberOfEntities() - 1
        
        if indexPath.row == lastItem {
            presenter?.getData(offset: i)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let model = presenter!.entityAt(indexPath: indexPath) as? Chat {
            if model.type == "Dialogue" {
                router?.showDetails(id: model.senderID)
            } else {
                router?.showDetails(id: 2000000000 + model.chatID)
            }
        }
    }
    
}

//MARK:- протокол ChatsListPresenterOutput
extension ChatsListViewController: ChatsListPresenterOutput {
    
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func insert(at: IndexPath) {
        tableView.insertRows(at: [at], with: .fade)
    }
    
    func delete(at: IndexPath) {
        tableView.deleteRows(at: [at], with: .fade)
    }
    
    func move(at: IndexPath, to: IndexPath) {
        tableView.moveRow(at: at, to: to)
    }
    
    func update(at: IndexPath) {
        tableView.reloadRows(at: [at], with: .fade)
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
}
