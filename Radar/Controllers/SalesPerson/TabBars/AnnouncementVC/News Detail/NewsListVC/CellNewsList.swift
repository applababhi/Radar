//
//  CellNewsList.swift
//  Unefon
//
//  Created by Abhishek Visa on 4/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellNewsList: UITableViewCell {

    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var btnDownload:UIButton!
    
    @IBOutlet weak var c_imgView_Ht_iPad:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
