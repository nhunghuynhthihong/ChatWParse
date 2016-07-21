//
//  ChatTableViewCell.swift
//  ChatWParse
//
//  Created by Nhung Huynh on 7/19/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLaebel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
