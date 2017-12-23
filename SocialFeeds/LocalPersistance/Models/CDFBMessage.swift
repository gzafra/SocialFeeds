//
//  CDFBMessage+CoreDataClass.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CDFBMessage)
public class CDFBMessage: NSManagedObject {}

extension CDFBMessage {
    func populate(with fbMessage: FBMessage) {
        identifier = fbMessage.identifier
        message = fbMessage.message
        username = fbMessage.user?.username
        userId = fbMessage.user?.identifier
        createdDate = fbMessage.creationTime as NSDate
    }
    
    var fbMessage: FBMessage {
        let user = FBUser(identifier: userId ?? "", username: username ?? "")
        return FBMessage(identifier: identifier ?? "", creationTime: (self.createdDate! as Date), message: message ?? "", user: user)
    }
}
