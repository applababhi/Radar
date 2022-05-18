//
//  CustomPopUpRewardView.swift
//  Radar
//
//  Created by Shalini Sharma on 25/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CustomPopUpRewardView: UIView {

    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var popView:UIView!
    @IBOutlet weak var lblPoints:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
        
    override init(frame: CGRect) {  // use when u init this view via programatically
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {  // use when u init this view via Stroyboard/Xib
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        
        // Load XIB
        Bundle.main.loadNibNamed("CustomPopUpRewardView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.frame
        popView.layer.cornerRadius = 10.0
        popView.layer.masksToBounds = true
    }
}
