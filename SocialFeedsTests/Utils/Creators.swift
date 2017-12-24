//
//  Creators.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 24/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
@testable import SocialFeeds

extension FBMessage {
    static func createMessagesArray(numberOfElements: Int = 2) -> [FBMessage] {
        var messages = [FBMessage]()
        
        for i in 0..<numberOfElements {
            let message = createMessage(identifier: "\(i)")
            messages.append(message)
        }
        
        return messages
    }
    
    static func createMessage(identifier: String) -> FBMessage {
        return FBMessage(identifier: identifier, creationTime: Date(), message: "A random message", user: FBUser(identifier: "1", username: "Username"))
    }
}

extension FBUser {
    static func createUser() -> FBUser {
        return FBUser(identifier: "20528438720", username: "Microsoft")
    }
}
