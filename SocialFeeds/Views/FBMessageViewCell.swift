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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var networkIcon: UIImageView!
    
    func configure(with message: FBMessageViewModel) {
        icon.image = message.image
        icon.roundedCorners()
        networkIcon.image = ImageKeys.facebookIcon.image
        networkIcon.roundedCorners()
        messageTextLabel.text = message.messageText
        userName.text = message.username
    }
}

private extension UIImageView {
    func roundedCorners() {
        self.layer.cornerRadius = self.frame.size.height * 0.1
        self.clipsToBounds = true
    }
}
