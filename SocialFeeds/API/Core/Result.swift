//
//  Result.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}