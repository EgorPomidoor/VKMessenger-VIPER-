//
//  LeftDetailChatCell.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class LeftDetailChatCell: UITableViewCell {

    @IBOutlet weak var lableView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lableView.layer.cornerRadius = 10
        lableView.clipsToBounds = true
    }

    func configureSelf(model: DetailChatModel) {
        messageLabel.text = model.body
    }
    
}
