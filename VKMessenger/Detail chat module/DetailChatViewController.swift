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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let kRightCellNIB = UINib(nibName: "RightDetailChatCell", bundle: nil)
    let kRightCellIdentifier = "RightCellIdentifier"
    let kLeftCellNIB = UINib(nibName: "LeftDetailChatCell", bundle: nil)
    let kLeftCellIdentifier = "LeftCellIdentifier"
    
    let topBorderView: UIView = {
        let topView = UIView()
        topView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return topView
    }()
    
    let leftBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        return item
    }()
    
   // let colletionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(kRightCellNIB, forCellReuseIdentifier: kRightCellIdentifier)
        tableView.register(kLeftCellNIB, forCellReuseIdentifier: kLeftCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        textField.delegate = self
        
        presenter?.getData(offset: 0)
        setUpInputComponents()
        notificationCenter()
    }
    
    //программно инициализируем view, который является прослойкой м/у таблицей и вью текст филда
    private func setUpInputComponents() {
        viewForTextField.addSubview(topBorderView)

        viewForTextField.addConstraintsWithFormat("H:|[v0]|", views: topBorderView)
        viewForTextField.addConstraintsWithFormat("V:|[v0(1)]", views: topBorderView)
        
        sendButton.isEnabled = false
//        let add = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(addTapped))
//        let play = UIBarButtonItem(title: "Play", style: .plain, target: self, action: #selector(addTapped))
//
//        navigationItem.rightBarButtonItems = [add, play]
//        
//        let collection = UIBarButtonItem.init(customView: colletionView)
//        navigationItem.leftBarButtonItem = collection
        
    }
    
    
    private func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
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
    
    @objc func addTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessage() {
        let message = textField.text
        presenter?.sendMessage(message: message!)
        
        
        textField.text = ""
        sendButton.isEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool {
       return false
    }
}

//MARK:- протокол UITextFieldDelegate
extension DetailChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //позволяет дизэйблить кнопку отправки, если textField пуст
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        if newText.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        return true
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        textField.endEditing(true)
//    }
}

//MARK:- протокол DetailChatPresenterOutput
extension DetailChatViewController: DetailChatPresenterOutput {
    //не используем
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func scroll(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    //методы для FRC
    func beginUpdates() {
        tableView.beginUpdates()
    }
    
    func insert(at: IndexPath) {
        tableView.insertRows(at: [at], with: .automatic)
    }
    
    func delete(at: IndexPath) {
        tableView.deleteRows(at: [at], with: .fade)
    }
    
    func move(at: IndexPath, to: IndexPath) {
        tableView.deleteRows(at: [at], with: .automatic)
        tableView.insertRows(at: [to], with: .fade)
    }
    
    func update(at: IndexPath) {
        tableView.reloadRows(at: [at], with: .fade)
    }
    
    func endUpdates() {
        tableView.endUpdates()
    }
}

