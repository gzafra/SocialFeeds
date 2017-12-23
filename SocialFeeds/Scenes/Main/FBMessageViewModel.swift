//
//  FBMessageViewModel.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit

final class FBMessageViewModel: SocialFeedItem {
    private let fbMessage: FBMessage
    private let fbUser: FBUser
    
    var messageText: String {
        return fbMessage.message ?? ""
    }
    
    var image: UIImage {
        return ImageKeys.placerHolderUser.image
    }
    
    var username: String {
        return fbUser.username
    }
    
    var sortDate: Date {
        return fbMessage.creationTime
    }
    
    init(_ message: FBMessage, user: FBUser) {
        self.fbMessage = message
        self.fbUser = user
    }
}
