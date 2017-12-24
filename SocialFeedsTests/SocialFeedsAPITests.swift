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
    private var fbMessage: FBMessage? {
        guard let data = loadJson(withName: "MockFacebookMessage") else {
            XCTFail("Failed to load json file")
            return nil
        }
        guard let repo = try? JSONDecoder().decode(FBMessage.self, from: data) else {
            XCTFail("Failed to decode JSON")
            return nil
        }
        return repo
    }

    func testFBMessage() {
        guard let message = fbMessage else { return }
        
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
        guard let message = fbMessage else { return }
    
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
    
    private var tweet: Tweet? {
        guard let data = loadJson(withName: "MockTweet") else {
            XCTFail("Failed to load MockTweet json file")
            return nil
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options:.allowFragments),
            let jsonArray = json as? [[AnyHashable: Any]],
            let dict = jsonArray.first,
            let tweet = Tweet(jsonDictionary: dict) else {
            XCTFail("Failed to decode JSON")
            return nil
        }
        return tweet
    }
    
    func testTwitterModel() {
        guard let tweet = tweet else { return }
        XCTAssertEqual(tweet.identifier, tweet.model.tweetID)
        XCTAssertEqual(tweet.model.author.screenName, "twitterapi")
    }
    
    func testTwitterWorker() {
        let twitterWorker = TwitterWorker()

        testExpectation(description: "Querying Twitter API", actionBlock: { (expectation) in
            twitterWorker.fetchTweets(with: { (result) in
                switch result {
                case .success(let tweets):
                    XCTAssert(tweets.count > 0)
                case .failure(_ ):
                    XCTFail("Request failed")
                    
                }
                expectation.fulfill()
            })
        }, waitFor: timeout)
    }

}
