//
//  CellEditProfile_Name.swift
//  Radar
//
//  Created by Shalini Sharma on 21/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class CellEditProfile_Name: UITableViewCell {

    @IBOutlet weak var tfName: HoshiTextField!
    @IBOutlet weak var btnUpdate:UIButton!
    
    var completion: (String) -> Void = {(tfStr:String) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellEditProfile_Name: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        completion(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
