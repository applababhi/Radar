//
//  CellEditProfile_Password.swift
//  Radar
//
//  Created by Shalini Sharma on 21/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class CellEditProfile_Password: UITableViewCell {

    @IBOutlet weak var tfOld: HoshiTextField!
    @IBOutlet weak var tfNew: HoshiTextField!
    @IBOutlet weak var tfConfirm: HoshiTextField!
    
    @IBOutlet weak var btnUpdate:UIButton!
    
    var completion: (String, Int) -> Void = {(tfStr:String, tfTag:Int) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellEditProfile_Password: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        completion(textField.text!, textField.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
