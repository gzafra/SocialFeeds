//
//  TwitterWorker.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import TwitterKit

typealias TwitterCompletionBlock = (Result<[Tweet]>)->()

final class TwitterWorker {
    
    enum Keys: String {
        case screenName = "screen_name"
        case count
    }
    
    init() {
        Twitter.sharedInstance().start(withConsumerKey:MainSettings.twitterConsumerKey.key!,
                                       consumerSecret:MainSettings.twitterConsumerSecret.key!)
    }
    
    public func fetchTweets(fromUser username: String, count: Int = 20, withCompletion completion: @escaping TwitterCompletionBlock) {
        let client = TWTRAPIClient()
        // TODO: Move to config
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = [Keys.screenName.rawValue: username,
                      Keys.count.rawValue: String(describing: count)]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
                completion(.failure(connectionError!))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[AnyHashable: Any]] {
                    var tweets = [Tweet]()
                    for item in json {
                        guard let twitterObject = Tweet(jsonDictionary: item) else { continue }
                        tweets.append(twitterObject)
                    }
                    completion(.success(tweets))
                }
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
    }
}

// MARK: - TWTRTweet Extension

extension TWTRTweet: SocialFeedItem {
    var sortDate: Date {
        return self.createdAt
    }
    
    var searchableText: String {
        return self.author.name + self.text
    }
}
