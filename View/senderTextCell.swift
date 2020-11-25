//
//  senderTextCell.swift
//  VarsKeyChat
//
//  Created by Ahmed Shoman on 7/18/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class senderTextCell: UITableViewCell {

    @IBOutlet weak var messageBodyLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
