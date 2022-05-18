//
//  FirstVC.swift
//  Radar
//
//  Created by Shalini Sharma on 27/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class FirstVC: UIViewController {
    
    @IBOutlet weak var tfDropDown: HoshiTextField!
    
    var arrPicker:[[String:Any]] = []
    var picker : UIPickerView!
    var dictPickerSelected:[String:Any] = [:]
    
    var strSelectedPickerValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewBackgroundImage(name: "")
        hideKeyboardWhenTappedAround()
        addRightPaddingTo(textField: tfDropDown, imageName: "dropDown")
        
        tfDropDown.placeholder = "Selecciona tu Distribuidor"
        tfDropDown.placeholderColor = .lightGray
        tfDropDown.borderActiveColor = k_baseColor
        tfDropDown.borderInactiveColor = .lightGray
        tfDropDown.placeholderFontScale = 1.0
        tfDropDown.delegate = self
        
        callSelectPlans()
    }
    
    @IBAction func btnTermsClick(btn:UIButton){
        
    }
    
    @IBAction func btnPrivacyClick(btn:UIButton){
        DispatchQueue.main.async {
            if let url = URL(string: "https://inspirum.blob.core.windows.net/legal/aviso_de_privacidad.pdf") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func btnContinueClick(btn:UIButton){
        
        if dictPickerSelected.count > 0{
            
            if let planId:String = self.dictPickerSelected["plan_id"] as? String{
                k_userDef.setValue(planId, forKey: userDefaultKeys.plan.rawValue)
                k_userDef.synchronize()
                
                let vc:LoginVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "LoginVC_ID") as! LoginVC
                vc.strTitle = self.strSelectedPickerValue
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                present(vc, animated: true, completion: nil)
            }
        }
        else{
            self.showAlertWithTitle(title: "Alerta", message: "Seleccione el valor", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
}

extension FirstVC
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}


extension FirstVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if arrPicker.count != 0
        {
            // it's a picker
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfDropDown.text = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FirstVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfDropDown.inputView = self.picker
        
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
        tfDropDown.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfDropDown.resignFirstResponder()
    }
    
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfDropDown.resignFirstResponder()
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
        
        if let strValue:String = dict["plan_name"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
        if let strTitle:String = self.dictPickerSelected["plan_name"] as? String{
            self.tfDropDown.text =  strTitle
            strSelectedPickerValue =  strTitle
        }
    }
}


extension FirstVC{
    
    func callSelectPlans(){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        WebService.requestService(url: ServiceName.GET_SelectPlan, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //    print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            else
            {
                if let internalCode:Int = json["internal_code"] as? Int
                {
                    if internalCode != 0
                    {
                        // Display Error
                        if let msg:String = json["message"] as? String
                        {
                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrPicker = arr
                            DispatchQueue.main.async {
                                if self.arrPicker.count > 0{
                                    self.dictPickerSelected = self.arrPicker.first!
                                    if let strTitle:String = self.dictPickerSelected["plan_name"] as? String{
                                        self.strSelectedPickerValue =  strTitle
                                        self.tfDropDown.text =  strTitle
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
