//
//  CDFBMessage+CoreDataProperties.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//
//

import Foundation
import CoreData


extension CDFBMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFBMessage> {
        return NSFetchRequest<CDFBMessage>(entityName: "CDFBMessage")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var message: String?
    @NSManaged public var username: String?
    @NSManaged public var userId: String?

}
