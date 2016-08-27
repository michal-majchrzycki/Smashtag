//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Neían on 27.08.2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionTableViewController: UIViewController {
    
    @IBOutlet weak var mentionTableView: UITableView!
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                title = tweet.user.name
                
                if tweet.hashtags.count > 0 {
                    var hashtags = [Mention]()
                    for hashtag in tweet.hashtags {
                        hashtags.append(Mention.Hashtag(hashtag.keyword))
                    }
                    addMentions(hashtags)
                }
                
                if tweet.urls.count > 0 {
                    var urls = [Mention]()
                    for url in tweet.urls {
                        urls.append(Mention.URL(url.keyword))
                    }
                    addMentions(urls)
                }
                if tweet.media.count > 0 {
                    var mediaItems = [Mention]()
                    for mediaItem in tweet.media {
                        mediaItems.append(Mention.Image(mediaItem))
                    }
                    addMentions(mediaItems)
                }
                
                var userMentions = [Mention]()
                userMentions.append(Mention.UserMention("@\(tweet.user.screenName)"))
                if tweet.userMentions.count > 0 {
                    for userMention in tweet.userMentions {
                        userMentions.append(Mention.UserMention(userMention.keyword))
                    }
                }
                addMentions(userMentions)
            }
        }
    }
    
    private var mentions = [[Mention]]()
    private func addMentions(mentionsToInsert: [Mention]) {
        mentions.insert(mentionsToInsert, atIndex: mentions.count)
    }
    
    private enum Mention {
        case Hashtag(String)
        case URL(String)
        case UserMention(String)
        case Image(MediaItem)
        
        var description: String {
            switch self {
            
            case .Hashtag(let hashtag):
                return hashtag
            case .URL(let url):
                return url
            case .UserMention(let userMention):
                return userMention
            case .Image(let mediaItem):
                return mediaItem.url.absoluteString
            }
        }
        
        var type: String {
            switch self {
            
            case .Hashtag(_):
                return "Hasztagi"
            case .URL(_):
                return "Linki URL"
            case .UserMention(_):
                return "Użytkownicy"
            case .Image(_):
                return "Grafiki"
            }
        }
    }
    
    private struct Storyboard {
        static let TextCellIdentifier  = "TextCell"
        static let ImageCellIdentifier = "ImageCell"
        static let ShowImageSegue = "ShowImage"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section][indexPath.row]
        switch mention {
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - UITableViewDatasource
    
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }
    
      func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].first!.type
    }
    
      func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section][indexPath.row]
        
        switch mention {
        case .Image(let mediaItem):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellIdentifier, forIndexPath: indexPath) as! MentionImageCell
            cell.mediaItem = mediaItem
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TextCellIdentifier, forIndexPath: indexPath) as! MentionTextCell
            cell.mention = mention.description
            return cell
        }
    }
    
    
     override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let indexPath = mentionTableView.indexPathForSelectedRow {
            let mention = mentions[indexPath.section][indexPath.row]
            switch mention {
            case .URL(let urlString):
                if let url = NSURL(string: urlString) {
                    UIApplication.sharedApplication().openURL(url)
                }
                return false
            default: break
            }
        }
        return true
    }
    
}

