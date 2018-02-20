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
    let kVKMChatTableViewCellWithoutPhoto = UINib(nibName: "VKMChatTableViewCellWithoutPhoto", bundle: nil)
    let kVKMChatTableViewCellWithoutPhotoIdentifier = "VKMChatTableViewCellWithoutPhotoIdentifier"
    
    let refreshControl: UIRefreshControl = {
       let refresher = UIRefreshControl()
        refresher.tintColor = UIColor(red: 0, green: 90/255, blue: 37/255, alpha: 1)
        refresher.attributedTitle = NSAttributedString(string: "Обновление списка сообщений ...")
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refresher
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter?.getData(offset: 0)
    }
    
    private func setUp () {
        tableView.register(kVKMChatTableVIewCell, forCellReuseIdentifier: kVKMChatTableVIewCellReuseIdentifier)
        tableView.register(kVKMChatTableViewCellWithoutPhoto, forCellReuseIdentifier: kVKMChatTableViewCellWithoutPhotoIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func refresh() {
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
        
        let model = presenter?.entityAt(indexPath: indexPath) as! Chat
        
        if model.out == 1 || model.type == "Multichat" {
        let cell = tableView.dequeueReusableCell(withIdentifier: kVKMChatTableVIewCellReuseIdentifier, for: indexPath) as! VKMChatTableViewCell
            cell.configureSelf(model: model)
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kVKMChatTableViewCellWithoutPhotoIdentifier, for: indexPath) as! VKMChatTableViewCellWithoutPhoto
            cell.configureSelf(model: model)
            return cell
        }
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
                router?.showDetails(idForRequest: model.userID, currentChatID: model.id)
            } else {
                router?.showDetails(idForRequest: 2000000000 + model.chatID, currentChatID: model.id)
            }
        }
    }
    
}

//MARK:- протокол ChatsListPresenterOutput
extension ChatsListViewController: ChatsListPresenterOutput {
    
    //методы для FRC
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
        //tableView.moveRow(at: at, to: to) - бывает конфликт с insert
        tableView.deleteRows(at: [at], with: .automatic)
        tableView.insertRows(at: [to], with: .fade)
    }
    
    func update(at: IndexPath) {
        tableView.reloadRows(at: [at], with: .fade)
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
    
    //метод для refreshController'a
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
