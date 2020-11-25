//
//  usersTCell.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/11/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class usersTCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var userEmailLBL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
