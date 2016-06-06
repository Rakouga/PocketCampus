//
//  EverythingTableViewCell.swift
//  PocketCampus
//
//  Created by 伽 on 16/6/6.
//  Copyright © 2016年 罗浩伽. All rights reserved.
//

import UIKit

class EverythingTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    var everythingID:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
