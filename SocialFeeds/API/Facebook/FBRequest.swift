//
//  FBRequest.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

//https://graph.facebook.com/20528438720/feed?access_token=177173466206158|ee87195ad7aa400959768061ea79f098
struct FBPageRequest: ApiRequest {
    let pageId: String
    var urlRequest: URLRequest {
        guard let url = Endpoints.pageFeed.url,
            var urlComponents = URLComponents(string: String(format: url, pageId)),
            let appId = MainSettings.fbAppId.string,
            let appSecret = MainSettings.fbAppSecret.string else {
           fatalError("Error creating FBPageRequest")
         }
        
        urlComponents.query = "access_token=\(appId)|\(appSecret)"
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        return request
    }
    
    init(withPageId pageId: String) {
        self.pageId = pageId
    }
}

fileprivate enum Endpoints: String {
    case pageFeed = "fbPageFeed"
    
    var url: String? {
        guard let availableEndPoints = MainSettings.endpoints.dictionary,
            let endPoint = availableEndPoints[self.rawValue] else {
                return nil
        }
        return endPoint
    }
}