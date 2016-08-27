//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private struct Attributes {
        static let Hashtags = [
            NSForegroundColorAttributeName: UIColor.orangeColor()
        ]
        static let Urls = [
            NSForegroundColorAttributeName: UIColor.purpleColor()
        ]
        static let UserMentions = [
            NSForegroundColorAttributeName: UIColor.brownColor()
        ]
    }
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = tweet {
            
            let tweetText = NSMutableAttributedString(string: tweet.text)
            tweetText.addAttributes(Attributes.Hashtags, indexedKeywords: tweet.hashtags)
            tweetText.addAttributes(Attributes.Urls, indexedKeywords: tweet.urls)
            tweetText.addAttributes(Attributes.UserMentions, indexedKeywords: tweet.userMentions)
            for _ in tweet.media {
                tweetText.appendAttributedString(NSAttributedString(string: " 📷"))
            }
            tweetTextLabel?.attributedText = tweetText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) {
                        dispatch_async(dispatch_get_main_queue()) {

                            if profileImageURL == self.tweet?.user.profileImageURL {
                                self.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
}

private extension NSMutableAttributedString {
    func addAttributes(attrs: [String : AnyObject], indexedKeywords: [Tweet.IndexedKeyword]) {
        for indexedKeyword in indexedKeywords {
            self.addAttributes(attrs, range: indexedKeyword.nsrange)
        }
    }
}
