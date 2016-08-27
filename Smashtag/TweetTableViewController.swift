//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    // MARK: Model

    var tweets = [[Tweet]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let twitterRequestFetcher = TwitterRequestFetcher()
    
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
        static let ShowMentionSegue = "Show Mention Seugue"
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
    }
    
    // MARK: - Search
    
    private func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if twitterRequestFetcher.searchText != nil {
            twitterRequestFetcher.fetchRequest { tweets in
                if tweets.count > 0 {
                    self.tweets.insert(tweets, atIndex: 0)
                    self.tableView.reloadData()
                }
                sender?.endRefreshing()
            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = twitterRequestFetcher.searchText
        }
    }
    
    @IBAction func search() {
        refreshControl?.beginRefreshing()
        searchTextField.resignFirstResponder()
        setNewSearchRequest(searchTextField.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            setNewSearchRequest(textField.text)
        }
        return true
    }
    
    func setNewSearchRequest(searchText: String?) {
        searchTextField.text = searchText
        twitterRequestFetcher.searchText = searchText
        if twitterRequestFetcher.searchText != nil {
            UserDefaults.sharedInstance.insertRecentSearch(twitterRequestFetcher.searchText!)
        }
        tweets.removeAll()
        tableView.reloadData()
        refresh()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
    }
    
    
}
