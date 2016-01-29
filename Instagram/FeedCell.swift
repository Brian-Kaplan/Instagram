//
//  feedCellTableViewCell.swift
//  Instagram
//
//  Created by Brian Kaplan on 1/28/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var cellPicture: UIImageView!
    
    @IBOutlet weak var cellUsername: UILabel!
    
    @IBOutlet weak var cellProfilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
