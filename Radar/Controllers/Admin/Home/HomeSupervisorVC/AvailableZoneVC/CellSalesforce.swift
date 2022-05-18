//
//  CellSalesforce.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellSalesforce: UITableViewCell {

    @IBOutlet weak var imgVUser:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblVisit:UILabel!
    @IBOutlet weak var lblSales:UILabel!
    @IBOutlet weak var lblPOS:UILabel!
    @IBOutlet weak var btnDelete:UIButton!
    
    @IBOutlet weak var imgVVisit:UIImageView!
    @IBOutlet weak var imgVSales:UIImageView!
    @IBOutlet weak var imgVPOS:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
