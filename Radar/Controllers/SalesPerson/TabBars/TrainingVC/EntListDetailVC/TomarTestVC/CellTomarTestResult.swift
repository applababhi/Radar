//
//  CellTomarTestResult.swift
//  Unefon
//
//  Created by Shalini Sharma on 9/11/19.
//  Copyright © 2019 Shalini. All rights reserved.
//

import UIKit

class CellTomarTestResult: UITableViewCell {

    @IBOutlet weak var lblQuestion:UILabel!
    @IBOutlet weak var lblAns_Incorrect:UILabel!
    @IBOutlet weak var lblAns_Correct:UILabel!
    @IBOutlet weak var c_lblQ_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_lblCor_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_lblInc_Ht:NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
