//
//  VKMCollectionViewCell.swift
//  VKMessenger
//
//  Created by Егор on 25.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit
import SDWebImage

class VKMCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    func configureSelf (imageUrl: String) {
        photoImageView.sd_setImage(with: URL(string: imageUrl))
    }

}
