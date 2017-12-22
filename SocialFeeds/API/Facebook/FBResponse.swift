//
//  FBResponse.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation

struct FBResponse {
    let messages: [FBMessage]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

extension FBResponse: Decodable {
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        messages = try rootContainer.decode([FBMessage].self, forKey: .data)
    }
}
