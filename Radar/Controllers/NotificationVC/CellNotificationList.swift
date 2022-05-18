
//
//  CellNotificationList.swift
//  Radar
//
//  Created by Shalini Sharma on 3/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellNotificationList: UITableViewCell {

    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var viewNotification:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
