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
}

protocol MainPresenterDelegate: class {
    func didReloadData()
    func didFail(with error: String)
}

protocol SocialFeedItem {
    var sortDate: Date { get }
}

final class MainPresenter: MainControllerPresenter {
    // MARK: - Properties
    private var dataSource = [SocialFeedItem]()
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
        return dataSource.count
    }
    
    var title: String {
        return "Social Feeds"
    }
    
    func viewDidLoad() {
        // Facebook
        fbWorker.fetchMessages { (result) in
            switch result {
            case let .success(messages):
                self.add(items: messages.map({ FBMessageViewModel($0) }).filter({ !$0.messageText.isEmpty }))
                self.delegate?.didReloadData()
            case let .failure(error):
                self.delegate?.didFail(with: error.localizedDescription)
            }
        }
        
        // Twitter
        twitterWorker.fetchTweets { (result) in
            switch result {
            case let .success(tweets):
                self.add(items: tweets as [SocialFeedItem])
                self.delegate?.didReloadData()
            case let .failure(error):
                self.delegate?.didFail(with: error.localizedDescription)
            }
        }
    }
    
    func viewModel(forRow row: Int) -> SocialFeedItem {
        return dataSource[row]
    }
}
