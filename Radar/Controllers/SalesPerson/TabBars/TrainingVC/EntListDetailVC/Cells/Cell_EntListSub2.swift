//
//  Cell_EntListSub2.swift
//  Unefon
//
//  Created by Shalini Sharma on 7/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class Cell_EntListSub2: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var btnPlay:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setThumbnailToView(img:UIImage) {
        let backgroundImgView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImgView.image = img
        self.videoPlayer.insertSubview(backgroundImgView, at: 0)
    }
    
}
