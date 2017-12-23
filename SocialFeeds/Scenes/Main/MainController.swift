//
//  ViewController.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit
import TwitterKit

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, MainPresenterDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSearchBar: UISearchBar!
    
    // MARK: - Properties
    private let tweeCellIdentifier = "TweetCell"
    private let fbCellIdentifier = "FacebookCell"
    private var presenter: MainPresenter!
    
    private var filteredItems = [SocialFeedItem]()
 
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(withDelegate: self)
        
        title = presenter.title
        
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweeCellIdentifier)

        let dismissTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSearch))
        dismissTapRecognizer.cancelsTouchesInView = true
        tableView.addGestureRecognizer(dismissTapRecognizer)
        
        presenter.viewDidLoad()
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter.viewModel(forRow: indexPath.section)
        
        switch viewModel {
        case let fbMessage as FBMessageViewModel:
            let cell = tableView.dequeueReusableCell(withIdentifier: fbCellIdentifier, for: indexPath) as! FBMessageViewCell
            cell.configure(with: fbMessage)
            return cell
        case let tweet as TWTRTweet:
            let cell = tableView.dequeueReusableCell(withIdentifier: tweeCellIdentifier, for: indexPath) as! TWTRTweetTableViewCell
            cell.configure(with: tweet)
            return cell
        default:
            fatalError("Unknown ViewModel")
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = presenter.viewModel(forRow: indexPath.section)
        
        switch viewModel {
        case let tweet as TWTRTweet:
            return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: false)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    // MARK: - MainPresenterDelegate
    
    func shouldRefreshView() {
        tableView.reloadData()
    }
    
    func display(error: String) {
        UIAlertController.showAlert(withMessage: error, title: "Error", fromController: self)
    }
}

// MARK: - UISearchBarDelegate
extension MainController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        dismissSearch()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.filter(by: "")
        dismissSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filter(by: searchText)
    }
    
    @objc func dismissSearch() {
        filterSearchBar.resignFirstResponder()
    }
}

