//
//  SocialFeedsTests.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import XCTest
@testable import SocialFeeds

class SocialFeedsAPITests: XCTestCase {
    private let timeout: TimeInterval = 10.0
    
    // MARK: - Facebook API

    func testFBMessage() {
        guard let message = fbMessageFromJson else { return }
        
        let expectedDateString = "2017-12-22T23:47:18+0000"
        guard let expectedDate = DateFormatter.iso8601.date(from: expectedDateString) else {
            XCTFail("Failed to format date")
            return
        }

        XCTAssertEqual(message.message, "Coming soon… Eminem x Beyoncé #WalkOnWater music video Watch first on Apple Music. apple.co/_Revival")
        XCTAssertEqual(message.creationTime, expectedDate)
        XCTAssertEqual(message.identifier, "615085188507202_2164597720222600")
        XCTAssertNil(message.user)
    }
    
    func testFBPageRequest() {
        let page = "01"
        let fbRequest = FBPageRequest(withPageId: page)
        
        guard let appId = MainSettings.fbAppId.key,
            let appSecret = MainSettings.fbAppSecret.key else {
                XCTFail("Failed to load settings")
                return
        }
        
        let expectedUrlString = "https://graph.facebook.com/\(page)/posts?access_token=\(appId)|\(appSecret)"
        let escapedURL = expectedUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        XCTAssertNotNil(fbRequest.urlRequest)
        XCTAssertEqual(fbRequest.urlRequest.httpMethod, "GET")
        XCTAssertNotNil(fbRequest.urlRequest.url)
        XCTAssertEqual(fbRequest.urlRequest.url!.absoluteString, escapedURL)
    }
    
    func testFBMessageViewModel() {
        guard let message = fbMessageFromJson else { return }
    
        let viewModel = FBMessageViewModel(message)
        
        XCTAssertEqual(viewModel.messageText, message.message)
        XCTAssertEqual(viewModel.username, "")
        XCTAssertEqual(viewModel.sortDate, message.creationTime)
        XCTAssertTrue(viewModel.searchableText.contains(viewModel.messageText))
    }
    
    func testFBWorkerSuccess() {
        let fbWorker = FBWorker()
        let user = FBUser.createUser()
        testExpectation(description: "Querying Facebook API", actionBlock: { (expectation) in
            fbWorker.fetchMessages(forUser: user, with: { (result) in
                switch result {
                case .success(let messages):
                    XCTAssert(messages.count > 0)
                case .failure(_ ):
                    XCTFail("Request failed")
                    
                }
                expectation.fulfill()
            })
        }, waitFor: timeout)
    }
    
    // MARK: - Twitter API
    
    func testTwitterModel() {
        guard let tweet = tweetFromJson else { return }
        XCTAssertEqual(tweet.identifier, tweet.model.tweetID)
        XCTAssertEqual(tweet.model.author.screenName, "twitterapi")
    }
    
    func testTwitterWorker() {
        let twitterWorker = TwitterWorker()
        let count = 5
        
        testExpectation(description: "Querying Twitter API", actionBlock: { (expectation) in
            twitterWorker.fetchTweets(fromUser: "nvidia", count: count, withCompletion: { (result) in
                switch result {
                case .success(let tweets):
                    XCTAssert(tweets.count == count)
                case .failure(_ ):
                    XCTFail("Request failed")
                    
                }
                expectation.fulfill()
            })
        }, waitFor: timeout)
    }

}
