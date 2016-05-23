//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/05/20.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var textL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
