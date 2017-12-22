//
//  ApiRequest.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

protocol ApiRequest {
    var urlRequest: URLRequest { get }
}
