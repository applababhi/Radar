//
//  CellAssignList.swift
//  Radar
//
//  Created by Shalini Sharma on 12/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellAssignList: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCount:UILabel!
    @IBOutlet weak var imgV_User:UIImageView!
    @IBOutlet weak var imgV_Loc:UIImageView!
    @IBOutlet weak var btnAdd:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
