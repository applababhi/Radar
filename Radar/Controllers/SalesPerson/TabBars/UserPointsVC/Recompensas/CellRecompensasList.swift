//
//  CellRecompensasList.swift
//  Radar
//
//  Created by Shalini Sharma on 4/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CellRecompensasList: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
