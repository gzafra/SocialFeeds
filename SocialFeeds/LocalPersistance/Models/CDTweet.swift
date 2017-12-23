//
//  CDTweet+CoreDataClass.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//
//

import Foundation
import CoreData
import TwitterKit

@objc(CDTweet)
public class CDTweet: NSManagedObject {}

extension CDTweet {
    func populate(with tweetModel: TWTRTweet) {
        let json = try? JSONSerialization.data(withJSONObject: tweetModel, options: .prettyPrinted) as NSData
        self.jsonData = json
    }
    
    var tweet: TWTRTweet? {
        guard let data = self.jsonData,
        let dictionary = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! [AnyHashable: Any] else {
                return nil
        }
        return TWTRTweet(jsonDictionary: dictionary)
    }
}
