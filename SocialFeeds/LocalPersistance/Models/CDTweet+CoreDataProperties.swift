//
//  CDTweet+CoreDataProperties.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//
//

import Foundation
import CoreData


extension CDTweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTweet> {
        return NSFetchRequest<CDTweet>(entityName: "CDTweet")
    }

    @NSManaged public var jsonData: NSData?
    @NSManaged public var identifier: String?

}
