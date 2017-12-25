//
//  FBUser.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

struct FBUser {
    let identifier: String
    let username: String
}


extension FBUser: Equatable {
    public static func ==(lhs: FBUser, rhs: FBUser) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.username == rhs.username
    }
}

