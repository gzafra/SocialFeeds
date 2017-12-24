//
//  CoreDataWorker.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 23/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import Foundation
import CoreData
import TwitterKit

final class CoreDataWorker {
    let viewContext: NSManagedObjectContextProtocol
    
    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }
    
    // MARK: - Fetching
    
    func fetchTweets(completionHandler: @escaping (Result<[TWTRTweet]>) -> Void) {
        if let coreDataTweets = try? viewContext.allEntities(withType: CDTweet.self) {
            let tweets = coreDataTweets.flatMap { $0.tweet }
            completionHandler(.success(tweets))
        } else {
            completionHandler(.failure(CoreErrors.coreDataLoadFailed(message: "Failed retrieving Tweets from Core Data")))
        }
    }

    func fetchFBMessages(completionHandler: @escaping (Result<[FBMessage]>) -> Void) {
        if let coreDataMessages = try? viewContext.allEntities(withType: CDFBMessage.self) {
            let fbMessages = coreDataMessages.map { $0.fbMessage }
            completionHandler(.success(fbMessages))
        } else {
            completionHandler(.failure(CoreErrors.coreDataLoadFailed(message: "Failed retrieving FBMessages from Core Data")))
        }
    }
    
    // MARK: - Saving
    
    func save(tweets: [Tweet], completionHandler: ((Result<[CDTweet]>) -> Void)? = nil) {
        var savedTweets = [CDTweet]()
        for tweet in tweets {
            let predicate = NSPredicate(format: "identifier==%@", tweet.identifier)
            guard let coreDataTweet = viewContext.entity(withType: CDTweet.self, predicate: predicate) else {
                completionHandler?(.failure(CoreErrors.coreDataSaveFailed(message: "Failed saving Tweets in Core Data")))
                return
            }
            
            coreDataTweet.populate(with: tweet)
            savedTweets.append(coreDataTweet)
        }
        
        do {
            try viewContext.save()
            completionHandler?(.success(savedTweets))
        } catch {
            completionHandler?(.failure(CoreErrors.coreDataSaveFailed(message: "Failed saving the context")))
        }
    }
    
    func save(fbMessages: [FBMessage], completionHandler: ((Result<[CDFBMessage]>) -> Void)? = nil) {
        var savedMessages = [CDFBMessage]()
        for fbMessage in fbMessages {
            let predicate = NSPredicate(format: "identifier==%@", fbMessage.identifier)
            guard let coreDataMessage = viewContext.entity(withType: CDFBMessage.self, predicate: predicate) else {
                completionHandler?(.failure(CoreErrors.coreDataSaveFailed(message: "Failed saving FBMessage in Core Data")))
                return
            }
            
            coreDataMessage.populate(with: fbMessage)
            savedMessages.append(coreDataMessage)
        }
        
        do {
            try viewContext.save()
            completionHandler?(.success(savedMessages))
        } catch {
            completionHandler?(.failure(CoreErrors.coreDataSaveFailed(message: "Failed saving the context")))
        }
    }
}
