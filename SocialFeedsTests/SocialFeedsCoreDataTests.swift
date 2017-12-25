//
//  SocialFeedsCoreDataTests.swift
//  SocialFeedsTests
//
//  Created by Guillermo Zafra on 25/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import XCTest
@testable import SocialFeeds


class SocialFeedsCoreDataTests: XCTestCase {
    private let memoryCoreDataStack = MemoryCoreDataStack()
    private let timeout: TimeInterval = 5.0
    
    // MARK: Saving
    
    func testSaveTweet() {
        let context = memoryCoreDataStack.persistentContainer.viewContext
        let coreDataWorker = CoreDataWorker(viewContext: context)
        
        guard let tweet = tweetFromJson else { return }
        
        testExpectation(description: "Saving to CoreData", actionBlock: { (expectation) in
            coreDataWorker.save(tweets: [tweet]) { (result) in
                switch result {
                case .success(let tweets):
                    XCTAssert(tweets.count == 1)
                    XCTAssertEqual(tweets.first!.identifier, tweet.identifier)
                    XCTAssertNotNil(tweets.first!.tweet)
                case .failure(_ ):
                    XCTFail("Saving to Core Data Failed")
                    
                }
                expectation.fulfill()
            }
        }, waitFor: timeout)
    }

    func testSaveMessage() {
        let context = memoryCoreDataStack.persistentContainer.viewContext
        let coreDataWorker = CoreDataWorker(viewContext: context)
        
        guard let mock = fbMessageFromJson else { return }
        let message = FBMessage(identifier: mock.identifier, creationTime: mock.creationTime, message: mock.message, user: FBUser.createUser())
        
        testExpectation(description: "Saving to CoreData", actionBlock: { (expectation) in
            coreDataWorker.save(fbMessages: [message], completionHandler: { (result) in
                switch result {
                case .success(let messages):
                    XCTAssert(messages.count == 1)
                    XCTAssertEqual(messages.first!.identifier, message.identifier)
                    XCTAssertEqual(messages.first!.message, message.message)
                    XCTAssertEqual(messages.first!.createdDate, message.creationTime as NSDate)
                    XCTAssertEqual(messages.first!.userId, message.user?.identifier)
                    XCTAssertEqual(messages.first!.username, message.user?.username)
                case .failure(_ ):
                    XCTFail("Saving to Core Data Failed")
                    
                }
                expectation.fulfill()
            })
        }, waitFor: timeout)
    }
    
    // MARK: Fetching
    
    func testFetchSavedTweets() {
        let context = memoryCoreDataStack.persistentContainer.viewContext
        let coreDataWorker = CoreDataWorker(viewContext: context)
        
        guard let tweet = tweetFromJson else { return }
        
        testExpectation(description: "Saving and Fetching", actionBlock: { (expectation) in
            coreDataWorker.save(tweets: [tweet]) { (savingResult) in
                switch savingResult {
                case .success(let savedTweets):
                    
                    coreDataWorker.fetchTweets(completionHandler: { (fetchResult) in
                        switch fetchResult {
                        case .success(let fetchedTweets):
                            XCTAssert(fetchedTweets.count == savedTweets.count)
                            XCTAssertNotNil(savedTweets.first!.tweet)
                            XCTAssertEqual(fetchedTweets.first!, savedTweets.first!.tweet!)
                            
                        case .failure(_ ):
                            XCTFail("Fetching from Core Data Failed")
                        }
                        expectation.fulfill()
                    })

                case .failure(_ ):
                    XCTFail("Saving to Core Data Failed")
                }
            }
        }, waitFor: timeout)
    }
    
    func testFetchSavedMessages() {
        let context = memoryCoreDataStack.persistentContainer.viewContext
        let coreDataWorker = CoreDataWorker(viewContext: context)
        
        guard let mock = fbMessageFromJson else { return }
        let message = FBMessage(identifier: mock.identifier, creationTime: mock.creationTime, message: mock.message, user: FBUser.createUser())
        
        testExpectation(description: "Saving and Fetching", actionBlock: { (expectation) in
            coreDataWorker.save(fbMessages: [message], completionHandler: { (result) in
                switch result {
                case .success(let savedMessages):
                    coreDataWorker.fetchFBMessages(completionHandler: { (fetchResult) in
                        switch fetchResult {
                        case .success(let fetchedMessages):
                            XCTAssert(savedMessages.count == fetchedMessages.count)
                            XCTAssertEqual(savedMessages.first!.fbMessage, fetchedMessages.first!)
                        case .failure(_ ):
                            XCTFail("Fetching from Core Data Failed")
                            
                        }
                        expectation.fulfill()
                    })
                case .failure(_ ):
                    XCTFail("Saving to Core Data Failed")
                    
                }
            })
        }, waitFor: timeout)
    }
}
