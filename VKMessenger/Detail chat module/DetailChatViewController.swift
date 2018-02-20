//
//  DetailChatViewController.swift
//  VKMessenger
//
//  Created by Егор on 06.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}


class DetailChatViewController: UIViewController {
    
    var presenter: DetailChatPresenterInput?
    
    @IBOutlet weak var movableConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewForTextField: UIView!
    @IBOutlet weak var tableView: UITableView!
    let kRightCellNIB = UINib(nibName: "RightDetailChatCell", bundle: nil)
    let kRightCellIdentifier = "RightCellIdentifier"
    let kLeftCellNIB = UINib(nibName: "LeftDetailChatCell", bundle: nil)
    let kLeftCellIdentifier = "LeftCellIdentifier"
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите сообщение..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Отправить", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let topBorderView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return topView
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(kRightCellNIB, forCellReuseIdentifier: kRightCellIdentifier)
        tableView.register(kLeftCellNIB, forCellReuseIdentifier: kLeftCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter?.getData(offset: 0)
        
        setUpInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    //программно инициализируем view, внутри которого программно иницализируем textField и button
    private func setUpInputComponents() {
//        view.addSubview(messageInputContainerView)
//        view.addConstraintsWithFormat("H:|[v0]|", views: messageInputContainerView)
//        view.addConstraintsWithFormat("V:[v0(48)]", views: messageInputContainerView)
//
//        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//        view.addConstraint(bottomConstraint!)
//
//        messageInputContainerView.addSubview(inputTextField)
//        messageInputContainerView.addSubview(sendButton)
//        messageInputContainerView.addSubview(topBorderView)
//        viewForTextField.addSubview(inputTextField)
//        viewForTextField.addSubview(sendButton)
//
//        viewForTextField.addConstraintsWithFormat("H:|-8-[v0][v1(90)]|", views: inputTextField, sendButton)
//        viewForTextField.addConstraintsWithFormat("V:|[v0]|", views: inputTextField)
//        viewForTextField.addConstraintsWithFormat("V:|[v0]|", views: sendButton)
        viewForTextField.addSubview(topBorderView)

        viewForTextField.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
        viewForTextField.addConstraintsWithFormat("V:|[v0(1)]", views: topBorderView)
        
    }
    
    //функция для notificationCenter
    @objc func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboargShowing = notification.name == .UIKeyboardWillShow
            
            movableConstraint.constant = isKeyboargShowing ? -keyboardFrame.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(completion) in
                
                if isKeyboargShowing {
                    let indexPath = IndexPath(row: (self.presenter?.numberOfEntities())! - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
}

//MARK:- протокол UITableViewDataSource
extension DetailChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter != nil ? presenter!.numberOfEntities() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = presenter?.entityAt(indexPath: indexPath) as! DetailChat
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        inputTextField.endEditing(true)
    }
}

//MARK:- протокол DetailChatPresenterOutput
extension DetailChatViewController: DetailChatPresenterOutput {
    //не используем
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: ((self.presenter?.numberOfEntities())! - 1), section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func insert(at: IndexPath) {
        tableView.insertRows(at: [at], with: .fade)
        self.tableView.scrollToRow(at: IndexPath(row: ((self.presenter?.numberOfEntities())! - 1), section: 0), at: UITableViewScrollPosition.bottom, animated: false)
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

