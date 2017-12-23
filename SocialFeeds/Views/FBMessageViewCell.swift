//
//  FBMessageViewCell.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit

class FBMessageViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    func configure(with message: FBMessageViewModel) {
        icon.image = ImageKeys.facebookIcon.image
        icon.layer.cornerRadius = icon.frame.size.height * 0.1
        icon.clipsToBounds = true
        messageTextLabel.text = message.messageText
    }
}
