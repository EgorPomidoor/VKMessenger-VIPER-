//
//  DetailChatViewController.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class DetailChatViewController: UIViewController {

    var presenter: DetailChatPresenterInput?
    
    @IBOutlet weak var tableView: UITableView!
    let kRightCellNIB = UINib(nibName: "RightDetailChatCell", bundle: nil)
    let kRightCellIdentifier = "RightCellIdentifier"
    let kLeftCellNIB = UINib(nibName: "LeftDetailChatCell", bundle: nil)
    let kLeftCellIdentifier = "LeftCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(kRightCellNIB, forCellReuseIdentifier: kRightCellIdentifier)
        tableView.register(kLeftCellNIB, forCellReuseIdentifier: kLeftCellIdentifier)
        tableView.dataSource = self

        presenter?.getData(offset: 0)
    }

}

//MARK:- протокол UITableViewDataSource
extension DetailChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter != nil ? presenter!.numberOfEntities() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let model = presenter!.entityAt(indexPath: indexPath) as! DetailChat
        
        if model.out == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kRightCellIdentifier, for: indexPath) as! RightDetailChatCell
            cell.configureSelf(model: model)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kLeftCellIdentifier, for: indexPath) as! LeftDetailChatCell
            cell.configureSelf(model: model)
            return cell

        }
    }
}

//MARK:- протокол DetailChatPresenterOutput
extension DetailChatViewController: DetailChatPresenterOutput {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: ((self.presenter?.numberOfEntities())! - 1), section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
}
