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

    @IBOutlet weak var messageTextLabel: UILabel!
    
    func configure(with message: FBMessageViewModel) {
        messageTextLabel.text = message.messageText
    }
}
