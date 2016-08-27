//
//  UserDefaults.swift
//  Smashtag
//
//  Created by Neían
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation

class UserDefaults {
    static let sharedInstance = UserDefaults()
    private init() {}
    
    struct Constants {
        static let RecentSearchesKey = "RecentSearches"
        static let MaxSearchesToSave = 100
        static let DefaultRecentSearch = "#wakacje"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private var recentSearches: [String] {
        get {
            if let recentSearches = defaults.objectForKey(Constants.RecentSearchesKey) as? [String] {
                return recentSearches
            } else {
                return [String]()
            }
        }
        set {
            defaults.setObject(newValue, forKey: Constants.RecentSearchesKey)
            defaults.synchronize()
        }
    }
    
    var allRecentSearches: [String] {
        return recentSearches
    }
    
    var latestRecentSearch: String {
        if let latestSearch = recentSearches.first {
            return latestSearch
        } else {
            return Constants.DefaultRecentSearch
        }
    }
    
    func insertRecentSearch(searchQuery: String) {
        let matches = recentSearches.filter { $0 == searchQuery }
        if matches.first != nil {
 
            if let indexToRemove = recentSearches.indexOf(matches.first!) {
                recentSearches.removeAtIndex(indexToRemove)
            }
        }
            if recentSearches.count >= Constants.MaxSearchesToSave {
            recentSearches.removeLast()
        }
        recentSearches.insert(searchQuery, atIndex: 0)
    }
    
    func removeRecentSearch(index: Int) {
        recentSearches.removeAtIndex(index)
    }
    
}