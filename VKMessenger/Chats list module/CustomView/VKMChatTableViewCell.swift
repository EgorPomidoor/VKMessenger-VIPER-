//
//  VKMChatTableViewCell.swift
//  VKMessenger
//
//  Created by Егор on 20.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit
import SDWebImage

class VKMChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var snippetConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    
    
    
    let kAvatarNIB = UINib(nibName: "VKMCollectionViewCell", bundle: nil)
    let kAvatarCellReuseIdentifier = "kAvatarCellReuseIdentifier"
    
    var usersArray: [Any]!
    var chat: Chat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(kAvatarNIB, forCellWithReuseIdentifier: kAvatarCellReuseIdentifier)
        collectionView.layer.cornerRadius = 35
        userImageView.layer.cornerRadius = 15
        userImageView.layer.masksToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureSelf(model: Chat) {
        
        chat = model
        
        if model.multichatPhoto == "empty" {
            usersArray = model.users?.allObjects
        } else {
            usersArray = [model.multichatPhoto]
        }
        
        if model.title != "" {
            nameLabel.text = model.title
        } else {
            nameLabel.text = (usersArray as! [User])[0].name
        }
        
        snippetLabel.text = model.snippet
        dateLabel.text = DateConvertion.convert(date: model.timestamp)
        
//        if model.out == 1 && model.type == "Dialogue" {
//
//            let id = Int64(VKMAuthService.sharedInstance.getMyID())
//            let user = CoreDataUserFabric.getUser(id: id!, contex: CoreDataManager.sharedInstance.getMainContext())
//
//            if user?.avatarURL != nil {
//                let avatarUrl = user!.avatarURL!
//                let photoURL = URL(string: avatarUrl)
//                userImageView.sd_setImage(with: photoURL)
//            }
//
//        } else if (model.out == 0 && model.type == "Multichat") {
//
//            let user = CoreDataUserFabric.getUser(id: model.senderID, contex: CoreDataManager.sharedInstance.getMainContext())
//
//            if user?.avatarURL != nil {
//                let avatarUrl = user!.avatarURL!
//                let photoURL = URL(string: avatarUrl)
//                userImageView.sd_setImage(with: photoURL)
//            }
//        } else {
//            userImageView.alpha = 0
//            snippetConstraint.constant = 20
//        }
      
        collectionView.reloadData()
    }
}


//MARK:- protocols UICollectionViewDataSource & UICOllectionViewDelegateFlowLAyout
extension VKMChatTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAvatarCellReuseIdentifier, for: indexPath) as! VKMCollectionViewCell
        
        if chat.multichatPhoto == "empty" {
            cell.configureSelf(imageUrl: (usersArray as! [User])[indexPath.item].avatarURL!)
        } else {
            cell.configureSelf(imageUrl: usersArray[0] as! String)
        }

        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if usersArray.count == 1 {
            return collectionView.frame.size
        } else if usersArray.count == 2 {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height/2)

        } 
        
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


