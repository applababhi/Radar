//
//  CellZoneDetailList.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellZoneDetailList: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    
    @IBOutlet weak var imgV_Level:UIImageView!
    @IBOutlet weak var imgV_User:UIImageView!
    
    @IBOutlet weak var vCircle_1:UIView!
    @IBOutlet weak var vCircle_2:UIView!
    @IBOutlet weak var vCircle_3:UIView!
    @IBOutlet weak var vCircle_4:UIView!
    @IBOutlet weak var vCircle_5:UIView!
    @IBOutlet weak var vCircle_6:UIView!
    @IBOutlet weak var vCircle_7:UIView!
    @IBOutlet weak var vCircle_8:UIView!
    @IBOutlet weak var vCircle_9:UIView!
    @IBOutlet weak var vCircle_10:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
