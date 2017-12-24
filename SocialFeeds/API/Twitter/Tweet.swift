//
//  Tweet.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 24/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import TwitterKit


final class Tweet {
    let identifier: String
    let jsonDictionary: [AnyHashable: Any]
    let model: TWTRTweet
    
    init?(jsonDictionary: [AnyHashable: Any]) {
        guard let twitterObject = TWTRTweet(jsonDictionary: jsonDictionary) else { return nil }
        self.identifier = twitterObject.tweetID
        self.jsonDictionary = jsonDictionary
        self.model = twitterObject
    }
}
