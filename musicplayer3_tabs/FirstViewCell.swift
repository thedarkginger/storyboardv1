//
//  FirstViewCell.swift
//  musicplayer3_tabs
//
//  Created by Himani Patel on 4/25/18.
//  Copyright © 2018 storyboard. All rights reserved.
//

import UIKit

class FirstViewCell: UITableViewCell {

    @IBOutlet weak var img_song: UIImageView!
  
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
  
    @IBOutlet weak var img_status: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
