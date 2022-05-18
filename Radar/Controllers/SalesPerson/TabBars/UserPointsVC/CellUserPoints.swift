//
//  CellUserPoints.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellUserPoints: UITableViewCell {

    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var lblPoints:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
