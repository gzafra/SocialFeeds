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

    func fetchMessages(forUser user: FBUser, with completionHandler: @escaping FBCompletionBlock) {
        let apiClient = ApiClient(urlSessionConfiguration: URLSessionConfiguration.default,
                                                completionHandlerQueue: OperationQueue.main)
        
        let request = FBPageRequest(withPageId: user.identifier)
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
