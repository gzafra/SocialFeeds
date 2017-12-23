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

    @IBOutlet weak var tableView: UITableView!
    private let tweeCellIdentifier = "TweetCell"
    private let fbCellIdentifier = "FacebookCell"
    private var presenter: MainPresenter!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(withDelegate: self)
        
        title = presenter.title
        
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweeCellIdentifier)

        presenter.viewDidLoad()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = presenter.viewModel(forRow: indexPath.row)
        
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


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = presenter.viewModel(forRow: indexPath.row)
        
        switch viewModel {
        case let tweet as TWTRTweet:
            return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.compact, width: self.view.bounds.width, showingActions: false)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    
    // MARK: - MainPresenterDelegate
    
    func didReloadData() {
        tableView.reloadData()
    }
    
    func didFail(with error: String) {
        UIAlertController.showAlert(withMessage: error, title: "Error", fromController: self)
    }
}

