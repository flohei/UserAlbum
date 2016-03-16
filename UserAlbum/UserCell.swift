//
//  UserCell.swift
//  UserAlbum
//
//  Created by Florian Heiber on 16.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var catchPhraseLabel: UILabel!
    
    var user: User? {
        didSet {
            self.updateInterface()
        }
    }
    
    func updateInterface() {
        guard let user = user else {
            return
        }
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        catchPhraseLabel.text = user.companyCatchPhrase
    }
}