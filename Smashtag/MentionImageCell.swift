//
//  MentionImageCell.swift
//  Smashtag
//
//  Created by Neían on 27.08.2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionImageCell: UITableViewCell {

        
        var mediaItem: MediaItem? {
            didSet {
                updateUI()
            }
        }
        
        @IBOutlet weak var mentionImageView: UIImageView!
    
        private var mentionImage: UIImage? {
            didSet {
                mentionImageView.image = mentionImage
            }
        }
        
        private func updateUI() {
            mentionImageView?.image = nil
            
            if let mediaItem = mediaItem {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    if let imageData = NSData(contentsOfURL: mediaItem.url) {
                        dispatch_async(dispatch_get_main_queue()) {
                            if mediaItem.url == self.mediaItem?.url {
                                self.mentionImage = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
        }
        
}
