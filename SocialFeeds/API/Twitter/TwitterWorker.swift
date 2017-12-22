//
//  TwitterWorker.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import TwitterKit

typealias TwitterCompletionBlock = ([TWTRTweet])->()

final class TwitterWorker {
    public func fetchTweets(with completion: @escaping TwitterCompletionBlock) {
        let client = TWTRAPIClient()
        // TODO: Move to config
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["screen_name": "twitterapi",
                      "count": "20"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[AnyHashable: Any]] {
                    var tweets = [TWTRTweet]()
                    for item in json {
                        guard let twitterObject = TWTRTweet(jsonDictionary: item) else { continue }
                        tweets.append(twitterObject)
                    }
                    completion(tweets)
                    print("json: \(json)")
                }
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
}
