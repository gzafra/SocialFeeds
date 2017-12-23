//
//  FBMessageViewModel.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit

final class FBMessageViewModel: SocialFeedItem {
    let fbMessage: FBMessage
    
    var messageText: String {
        return fbMessage.message ?? "..."
    }
    
    var sortDate: Date {
        return fbMessage.creationTime
    }
    
    init(_ message: FBMessage) {
        self.fbMessage = message
    }
}
