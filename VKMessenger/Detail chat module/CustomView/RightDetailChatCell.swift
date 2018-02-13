//
//  RightDetailChatCell.swift
//  VKMessenger
//
//  Created by Егор on 11.02.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

class RightDetailChatCell: UITableViewCell {

    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelView.layer.cornerRadius = 10
        labelView.clipsToBounds = true
    }

    func configureSelf(model: DetailChat) {
        messageLabel.text = model.body
    }
}
