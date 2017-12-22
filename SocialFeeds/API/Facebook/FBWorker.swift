//
//  FacebookWorker.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import TwitterKit

typealias FBCompletionBlock = (Result<[FBMessage]>)->()

final class FBWorker {
    //https://graph.facebook.com/20528438720/feed?access_token=177173466206158|ee87195ad7aa400959768061ea79f098
    
    init() {
        Twitter.sharedInstance().start(withConsumerKey:"i0LnoyxsE9Kc3rLdhXLLyuCQd", consumerSecret:"c3PH69TvOzhCGk73gw5qn9lDmBFxM5oMOh8aosMqmRruNq9exO")
    }
    
    func fetchMessages(with completionHandler: @escaping FBCompletionBlock) {
        let apiClient = ApiClient(urlSessionConfiguration: URLSessionConfiguration.default,
                                                completionHandlerQueue: OperationQueue.main)
        
        let request = FBPageRequest(withPageId: "20528438720")
        apiClient.execute(request: request) { (result: Result<ApiResponse<FBResponse>>) in
            switch result {
            case let .success(response):
                completionHandler(.success(response.entity.messages))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
