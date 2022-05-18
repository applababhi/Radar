//
//  CellZoneList.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellZoneList: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var viewIndicator1:UIView!
    @IBOutlet weak var viewIndicator2:UIView!
    @IBOutlet weak var viewIndicator3:UIView!
    @IBOutlet weak var imgVUser1:UIImageView!
    @IBOutlet weak var imgVUser2:UIImageView!
    @IBOutlet weak var imgVUser3:UIImageView!
    @IBOutlet weak var imgVUser4:UIImageView!
    @IBOutlet weak var imgVUser5:UIImageView!
    @IBOutlet weak var imgVUser6:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
