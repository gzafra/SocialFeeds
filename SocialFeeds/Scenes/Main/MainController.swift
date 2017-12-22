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
    private let tweeCellIdentifier = "TweetCell"
    private let fbCellIdentifier = "FacebookCell"
    private var items = [AnyObject]()
    private let fbWorker = FBWorker()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Social Feeds"
        
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweeCellIdentifier)

        fbWorker.fetchMessages { (result) in
            switch result {
            case let .success(messages):
                self.items = messages as [AnyObject]
                self.tableView.reloadData()
            case let .failure(error):
                UIAlertController.showAlert(withMessage: error.localizedDescription, title: "Error", fromController: self)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = items[indexPath.row] as? FBMessage else {
            fatalError("Incorrect type")
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: tweetTableReuseIdentifier, for: indexPath) as! TWTRTweetTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: fbCellIdentifier, for: indexPath)
        cell.textLabel?.text = item.message
//        cell.configure(with: tweet)
        return cell
    }


//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let tweet = items[indexPath.row]
//        return TWTRTweetTableViewCell.height(for: tweet, style: TWTRTweetViewStyle.regular, width: self.view.bounds.width, showingActions: false)
//    }
}

