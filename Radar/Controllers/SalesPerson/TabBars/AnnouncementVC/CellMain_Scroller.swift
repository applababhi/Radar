//
//  CellMain_Scroller.swift
//  Unefon
//
//  Created by on 1/7/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellMain_Scroller: UITableViewCell {
    
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var carouselView: AACarousel!
    @IBOutlet weak var lblTitle:UIInsetDownLabel!
    @IBOutlet weak var lblSubTitle:UIInsetUpLabel!
    @IBOutlet weak var btn:UIButton!
    @IBOutlet weak var vBlack:UIView!
    @IBOutlet weak var vBlack_Inner:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
