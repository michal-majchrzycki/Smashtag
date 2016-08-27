//
//  TwitterRequestFetcher.swift
//  Smashtag
//
//  Created by Neían
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation

class TwitterRequestFetcher {
    var searchText: String? = UserDefaults.sharedInstance.latestRecentSearch {
        didSet {
            lastSuccessfulRequest = nil
        }
    }
    
    private var lastSuccessfulRequest: TwitterRequest?
    private var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func fetchRequest(tweets: ([Tweet])->Void) {
        if let request = nextRequestToAttempt {
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        tweets(newTweets)
                        self.lastSuccessfulRequest = request
                    } else {
                        tweets([])
                    }
                }
            }
        }
    }
    
    
}