//
//  MainPresenter.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 22/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit

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
    private var dataSource = [SocialFeedItem]()
    private var filterKeyword: String = ""
    private let fbWorker = FBWorker()
    private let twitterWorker = TwitterWorker()
    fileprivate weak var delegate: MainPresenterDelegate?
    
    init(withDelegate delegate: MainPresenterDelegate) {
        self.delegate = delegate
    }
    
    private func add(items: [SocialFeedItem]) {
        // TODO: Ideally SocialFeedItems should be equatable to know if items are duplicated or have changed
        dataSource.append(contentsOf: items)
        dataSource.sort(by: { $0.sortDate.compare($1.sortDate) == .orderedDescending })
    }
    
    // MARK: - MainControllerPresenter
    var numberOfItems: Int {
        return dataSource.filtered(by: filterKeyword).count
    }
    
    var title: String {
        return "Social Feeds"
    }
    
    func viewDidLoad() {
        // Facebook
        // TODO: Usually we would query for user/page to get all info needed to create the ViewModel
        let user = FBUser(identifier: "20528438720", username: "Microsoft")
        fbWorker.fetchMessages(forUser: user) { (result) in
            switch result {
            case let .success(messages):
                self.add(items: messages.map({ FBMessageViewModel($0, user:user) }).filter({ !$0.messageText.isEmpty }))
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
        
        // Twitter
        twitterWorker.fetchTweets { (result) in
            switch result {
            case let .success(tweets):
                self.add(items: tweets as [SocialFeedItem])
                self.delegate?.shouldRefreshView()
            case let .failure(error):
                self.delegate?.display(error: error.localizedDescription)
            }
        }
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
