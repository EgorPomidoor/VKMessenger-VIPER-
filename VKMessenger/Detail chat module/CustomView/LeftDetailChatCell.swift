//
//  LeftDetailChatCell.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit
import SDWebImage

class LeftDetailChatCell: UITableViewCell {

    @IBOutlet weak var lableView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lableView.layer.cornerRadius = 10
        lableView.clipsToBounds = true
        avatarView.layer.cornerRadius = 25
        avatarView.layer.masksToBounds = true
    }

    func configureSelf(model: DetailChat) {
        messageLabel.text = model.body
        
        let userId = model.userID
        let user = CoreDataUserFabric.getUser(id: userId, contex: CoreDataManager.sharedInstance.getMainContext())
        avatarView.sd_setImage(with: URL(string: user?.avatarURL ?? ""))
    }
    
}
