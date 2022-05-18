//
//  CustomCalloutView.swift
//  GoogleMapDemo
//
//  Created by Shalini Sharma on 8/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var roundView:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var txtViewDesc:UITextView!
        
    // PLEASE NOTE : in it's Xib i intensionally added one extra view inside main view and made it's x, y go out pf bounds because, if i don't do that then, the view which appears in callout comes with Marker's padding
    

    // Create new file inherit from UIVIew, then Add newfile as View with same class name
    // then to change size of UIView, go to XIB, click on the attributes inspector in the upper right hand corner, and change size to freeform
    // to connect this code file with Xib, go to Xib, and click on the File’s Owner, then in Identity Inspector, enter the name of the UIView file class  "CustomCalloutView"
    // Now, u need to add this complete UIView(parent node) which u see in Xib file, as IBOutlt property in code
    // Now in last step, u need to refer ur nib file in this code file from Bundle.Main in commonInit function
     
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
        Bundle.main.loadNibNamed("CustomCalloutView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.frame
      
      //  self.layer.cornerRadius = 5.0
      //  self.layer.masksToBounds = true

      //  containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]        
    }
}
