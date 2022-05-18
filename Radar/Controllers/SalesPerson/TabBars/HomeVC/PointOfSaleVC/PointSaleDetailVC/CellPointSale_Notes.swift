//
//  CellPointSale_Notes.swift
//  Radar
//
//  Created by Shalini Sharma on 19/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class CellPointSale_Notes: UITableViewCell {

    var index:Int!
    @IBOutlet weak var tf: HoshiTextField!
    @IBOutlet weak var txtView: UITextView!
    
    var closure:(String,Bool, Int) -> Void = {(txt:String, isTxtView:Bool, index:Int) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CellPointSale_Notes: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        closure(textField.text!, false, index)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension CellPointSale_Notes: UITextViewDelegate
{
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            closure(textView.text!, true, index)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
