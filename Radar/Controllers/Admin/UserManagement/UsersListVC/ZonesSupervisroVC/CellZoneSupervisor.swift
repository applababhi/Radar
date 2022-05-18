//
//  CellZoneSupervisor.swift
//  Radar
//
//  Created by Shalini Sharma on 9/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellZoneSupervisor: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubtitle:UILabel!
    @IBOutlet weak var imgCross:UIImageView!
    @IBOutlet weak var btnCross:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
