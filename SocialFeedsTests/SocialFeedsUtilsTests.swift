//
//  SocialFeedsUtilsTests.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 24/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import XCTest
@testable import SocialFeeds

class SocialFeedsUtilsTests: XCTestCase {
    
    
    func testSettings() {
        XCTAssertNotNil(MainSettings.fbAppId.key)
        XCTAssertNotNil(MainSettings.fbAppSecret.key)
        XCTAssertNotNil(MainSettings.twitterConsumerKey.key)
        XCTAssertNotNil(MainSettings.twitterConsumerSecret.key)
        let endpoints = MainSettings.endpoints.dictionary
        XCTAssertNotNil(endpoints)
        XCTAssertTrue(endpoints!.keys.count > 0)
    }
    
    func testDateFormatter() {
        let stringDate = "2017-12-22T23:47:18+0000"
        let date = DateFormatter.iso8601.date(from: stringDate)
        XCTAssertNotNil(date)
    }
}
