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
    
    var messageText: String {
        return fbMessage.message ?? ""
    }
    
    var searchableText: String {
        return messageText + (fbMessage.user?.username ?? "")
    }
    
    var image: UIImage {
        return ImageKeys.placerHolderUser.image
    }
    
    var username: String {
        return fbMessage.user?.username ?? ""
    }
    
    var sortDate: Date {
        return fbMessage.creationTime
    }
    
    init(_ message: FBMessage) {
        self.fbMessage = message
    }
}
