//
//  CoreErrors.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

enum CoreErrors: Error {
    case coreDataLoadFailed(message: String)
    case coreDataSaveFailed(message: String)
}
