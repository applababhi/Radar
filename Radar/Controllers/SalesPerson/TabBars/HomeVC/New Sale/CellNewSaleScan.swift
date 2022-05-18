//
//  CellNewSaleScan.swift
//  Radar
//
//  Created by Shalini Sharma on 2/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class CellNewSaleScan: UITableViewCell {

    @IBOutlet weak var tfID: HoshiTextField!
    @IBOutlet weak var tfPicker: HoshiTextField!
    @IBOutlet weak var btnScan:UIButton!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var lblIDs:UILabel!
    
    var picker : UIPickerView!
    var arrPicker:[[String:Any]] = []
    var dictPickerSelected:[String:Any] = [:]
    var index:Int!
    
    var completion: ([String:Any], String, Int) -> () = {(dict:[String:Any], strValue:String, index:Int) in }    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func addRightView(imageName:String)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 60))
        viewT.backgroundColor = .clear
        
        tfPicker.rightViewMode = UITextField.ViewMode.always

        let imageView = CustomImageView(frame: CGRect(x: 0, y: 7, width: 16, height: 53))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        viewT.addSubview(imageView)
        
        imageView.textField = tfPicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.makeTFFirstResponder(senderView:)))
        imageView.addGestureRecognizer(tap)

        tfPicker.rightView = viewT
    }
    
    @objc func makeTFFirstResponder(senderView:UITapGestureRecognizer){
            if let imgV:CustomImageView = senderView.view as? CustomImageView {
                let tf:UITextField = imgV.textField
                tf.becomeFirstResponder()
            }
        }
}

extension CellNewSaleScan: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.tintColor = k_baseColor
        if textField == tfPicker
        {
            if arrPicker.count != 0
            {
                textField.tintColor = .clear
                // it's a picker
                showPickerView()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfPicker
        {
            completion(dictPickerSelected, textField.text!, index)
        }
        else{
            completion([:], textField.text!, index)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension CellNewSaleScan: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfPicker.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        tfPicker.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfPicker.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfPicker.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: CustomFont.regular, size: 19)
        pickerLabel.textColor = UIColor.black
        pickerLabel.textAlignment = .center
        pickerLabel.text = ""
        
        let dict:[String:Any] = arrPicker[row]
        
        if let strValue:String = dict["product_name"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
    }
}
