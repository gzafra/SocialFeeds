//
//  FBMessage.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
struct FBMessage {
    let identifier: String
    let creationTime: Date
    let message: String?
    var user: FBUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case message
        case created_time
    }
}

extension FBMessage: Equatable {
    public static func ==(lhs: FBMessage, rhs: FBMessage) -> Bool {
        return lhs.identifier == rhs.identifier
            && lhs.message == rhs.message
            && lhs.creationTime == rhs.creationTime
    }
}


extension FBMessage: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .id)
        
        let dateString = try container.decode(String.self, forKey: .created_time)
        let formatter = DateFormatter.iso8601
        if let date = formatter.date(from: dateString) {
            creationTime = date
        } else {
            throw ApiErrors.decodingError
        }
        message = try? container.decode(String.self, forKey: .message)
    }
}

