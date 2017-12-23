//
//  AppDelegate.swift
//  SocialFeeds
//
//  Created by Guillermo Zafra on 21/12/2017.
//  Copyright © 2017 Guillermo Zafra. All rights reserved.
//


// TODO: Search by words
// TODO: Cell actions
// TODO: CoreData cache
// TODO: Tests


import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Twitter.sharedInstance().start(withConsumerKey:MainSettings.twitterConsumerKey.key!,
                                       consumerSecret:MainSettings.twitterConsumerSecret.key!)
        return true
    }
}
