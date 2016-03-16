//
//  PhotoCell.swift
//  UserAlbum
//
//  Created by Florian Heiber on 16.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    var photo: Photo? {
        didSet {
            self.updateInterface()
        }
    }
    
    func updateInterface() {
        guard let photo = photo else {
            return
        }
        
        titleLabel.text = photo.title
        
        let thumbnailURL = NSURL(string: photo.thumbnailUrl!)
        if thumbnailURL != nil {
            thumbnailView.kf_setImageWithURL(thumbnailURL!)
        }
    }
}
