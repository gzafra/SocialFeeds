//
//  ViewController.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//

import UIKit
import TwitterKit

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let tweetTableReuseIdentifier = "TweetCell"
    private var items = [AnyObject]()
    private let fbWorker = FBWorker()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Social Feeds"
        
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)

        fbWorker.fetchMessages { (result) in
            switch result {
            case let .success(messages):
                self.items = messages as [AnyObject]
            case let .failure(error):
                UIAlertController.showAlert(withMessage: error.localizedDescription, title: "Error", fromController: self)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetTableReuseIdentifier, for: indexPath) as! TWTRTweetTableViewCell
        cell.configure(with: tweet)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweet = items[indexPath.row]
        return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.regular, width: self.view.bounds.width, showingActions: false)
    }
}

