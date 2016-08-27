//
//  MentionTextCell.swift
//  Smashtag
//
//  Created by Neían on 27.08.2016.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class MentionTextCell: UITableViewCell {
    @IBOutlet weak var mentionLabel: UILabel!
    
    var mention: String? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        mentionLabel?.text = mention
    }
    
}