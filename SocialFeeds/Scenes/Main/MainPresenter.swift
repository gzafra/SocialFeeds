//
//  MainPresenter.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit
import TwitterKit

protocol MainControllerPresenter {
    var numberOfItems: Int { get }
    var title: String { get }
    func viewDidLoad()
    func viewModel(forRow row: Int) -> SocialFeedItem
    func filter(by keyword: String)
}

protocol MainPresenterDelegate: class {
    func shouldRefreshView()
    func display(error: String)
}

protocol SocialFeedItem {
    /// Date by which the item will be sorted in the list
    var sortDate: Date { get }
    
    /// Raw text used in the search
    var searchableText: String { get }
}

final class MainPresenter: MainControllerPresenter {
    // MARK: - Properties
    
    private var tweets = [TWTRTweet]()
    private var messages = [FBMessageViewModel]()
    private var dataSource: [SocialFeedItem] {
        var mergedData = [SocialFeedItem]()
        mergedData.append(contentsOf: tweets as [SocialFeedItem])
        mergedData.append(contentsOf: messages as [SocialFeedItem])
        return mergedData.sorted(by: { $0.sortDate.compare($1.sortDate) == .orderedDescending })
    }
    private var filterKeyword: String = ""
    private let fbWorker = FBWorker()
    private let twitterWorker = TwitterWorker()
    private var coreDataWorker: CoreDataWorker!
    fileprivate weak var delegate: MainPresenterDelegate?
    
    init(withDelegate delegate: MainPresenterDelegate) {
        self.delegate = delegate
    }
    
    /// Fetchs remote data from different API Services and caches data into Core Data
    private func loadRemoteData() {
        // Facebook
        // FIXME: Usually we would query for user/page to get all info needed to create the ViewModel
        let user = FBUser(identifier: "20528438720", username: "Microsoft")
        fbWorker.fetchMessages(forUser: user) { (result) in
            switch result {
            case let .success(messages):
                self.messages = messages.map({ FBMessageViewModel($0) }).filter({ !$0.messageText.isEmpty })
                self.coreDataWorker.save(fbMessages: messages)
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
        
        // Twitter
        twitterWorker.fetchTweets(fromUser: "nvidia") { (result) in
            switch result {
            case let .success(tweets):
                self.tweets = tweets.map({ return $0.model })
                self.coreDataWorker.save(tweets: tweets)
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
    }
    
    // MARK: - MainControllerPresenter
    var numberOfItems: Int {
        return dataSource.filtered(by: filterKeyword).count
    }
    
    var title: String {
        return "Social Feeds"
    }
    
    func viewDidLoad() {
        // Setup Core Data
        coreDataWorker = CoreDataWorker(viewContext: CoreDataStack.shared.persistentContainer.viewContext)
        
        coreDataWorker.fetchFBMessages { (result) in
            switch result {
            case let .success(messages):
                self.messages = messages.map({ FBMessageViewModel($0) }).filter({ !$0.messageText.isEmpty })
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
        
        coreDataWorker.fetchTweets { (result) in
            switch result {
            case let .success(tweets):
                self.tweets = tweets
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
        
        loadRemoteData()
    }
    
    func viewModel(forRow row: Int) -> SocialFeedItem {
        return dataSource.filtered(by: filterKeyword)[row]
    }
    
    func filter(by keyword: String) {
        filterKeyword = keyword
        delegate?.shouldRefreshView()
    }
}

extension Sequence where Iterator.Element == SocialFeedItem {
    func filtered(by keyword: String) -> [SocialFeedItem] {
        guard !keyword.isEmpty else { return self as! [SocialFeedItem] }
        return self.filter({ $0.searchableText.localizedCaseInsensitiveContains(keyword) })
    }
}
