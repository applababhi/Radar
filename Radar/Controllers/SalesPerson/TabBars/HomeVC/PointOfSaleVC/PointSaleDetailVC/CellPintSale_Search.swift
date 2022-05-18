//
//  CellPintSale_Search.swift
//  Radar
//
//  Created by Shalini Sharma on 30/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class CellPintSale_Search: UITableViewCell {

    @IBOutlet weak var tfName: HoshiTextField!
    @IBOutlet weak var tfNumber: HoshiTextField!
    @IBOutlet weak var tfZipcode: HoshiTextField!
    @IBOutlet weak var tfNeighborhood: HoshiTextField!
    @IBOutlet weak var tfMunicipality: HoshiTextField!
    @IBOutlet weak var tfState: HoshiTextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    var picker : UIPickerView!
    var arrPicker:[String] = []
        
    var completion: (String, Int) -> () = {(strValue:String, index:Int) in }
    
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
        
        tfState.rightViewMode = UITextField.ViewMode.always

        let imageView = CustomImageView(frame: CGRect(x: 0, y: 7, width: 16, height: 53))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: imageName)
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        viewT.addSubview(imageView)
        
        imageView.textField = tfState
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.makeTFFirstResponder(senderView:)))
        imageView.addGestureRecognizer(tap)

        tfState.rightView = viewT
    }
    
    @objc func makeTFFirstResponder(senderView:UITapGestureRecognizer){
            if let imgV:CustomImageView = senderView.view as? CustomImageView {
                let tf:UITextField = imgV.textField
                tf.becomeFirstResponder()
            }
        }
}

extension CellPintSale_Search: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.tintColor = k_baseColor
        if textField.tag == 105
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
        completion(textField.text!, textField.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension CellPintSale_Search: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfState.inputView = self.picker
        
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
        tfState.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfState.resignFirstResponder()
    }
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfState.resignFirstResponder()
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
        
        pickerLabel.text = arrPicker[row]
        
        return pickerLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tfState.text =  arrPicker[row]
    }
}
