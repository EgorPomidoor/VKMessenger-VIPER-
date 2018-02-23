//
//  VKMChatTableViewCellWithoutPhoto.swift
//  VKMessenger
//
//  Created by Егор on 19.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit
import SDWebImage

class VKMChatTableViewCellWithoutPhoto: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var snippetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readStateImageView: UIImageView!
    @IBOutlet weak var readStateView: UIView!
    
    let kAvatarNIB = UINib(nibName: "VKMCollectionViewCell", bundle: nil)
    let kAvatarCellReuseIdentifier = "kAvatarCellReuseIdentifier"
    
    var usersArray: [Any]!
    var chat: Chat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(kAvatarNIB, forCellWithReuseIdentifier: kAvatarCellReuseIdentifier)
        collectionView.layer.cornerRadius = 40
        readStateView.layer.cornerRadius = 10

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
        
//        let allElements = model.messages!.sorted(by:{ ($0 as! DetailChat).date < ($1 as! DetailChat).date })
//        let count = allElements.count
//        let modell = model.messages?.count == 0 ? nil : allElements[count - 1] as? DetailChat
//
//        snippetLabel.text = model.messages?.count == 0 ? model.snippet : modell?.body
//        dateLabel.text =  model.messages?.count == 0 ? DateConvertion.convert(date: model.timestamp) : DateConvertion.convert(date: (modell?.date)!)
        
        
        readStateImageView.alpha = (model.out == 1 && model.readState == 0) ? 1 : 0
        readStateView.alpha = (model.out == 0 && model.readState == 0) ? 0.3 : 0

        collectionView.reloadData()
    }
}


//MARK:- protocols UICollectionViewDataSource & UICOllectionViewDelegateFlowLAyout
extension VKMChatTableViewCellWithoutPhoto: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

