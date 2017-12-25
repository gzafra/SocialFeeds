//
//  Creators.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 24/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import XCTest
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

extension XCTestCase {
    var tweetFromJson: Tweet? {
        guard let data = loadJson(withName: "MockTweet") else {
            XCTFail("Failed to load MockTweet json file")
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments),
            let jsonArray = json as? [[AnyHashable: Any]],
            let dict = jsonArray.first,
            let tweet = Tweet(jsonDictionary: dict) else {
                XCTFail("Failed to decode JSON")
                return nil
        }
        return tweet
    }
    
    var fbMessageFromJson: FBMessage? {
        guard let data = loadJson(withName: "MockFacebookMessage") else {
            XCTFail("Failed to load json file")
            return nil
        }
        guard let message = try? JSONDecoder().decode(FBMessage.self, from: data) else {
            XCTFail("Failed to decode JSON")
            return nil
        }
        return message
    }
}
