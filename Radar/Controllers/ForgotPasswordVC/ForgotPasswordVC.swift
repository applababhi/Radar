//
//  ForgotPasswordVC.swift
//  Radar
//
//  Created by Shalini Sharma on 12/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var tblView:UITableView!
    
    var strTFCell1 = ""
    var strTFCell2 = ""
    var strTFCell3_1 = ""
    var strTFCell3_2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ForgotPasswordVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 280
        }
        else if indexPath.row == 1
        {
            return 165
        }
        else{
            // last cell 2 tf
            return 215
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:CellForgot_1 = tblView.dequeueReusableCell(withIdentifier: "CellForgot_1", for: indexPath) as! CellForgot_1
            cell.selectionStyle = .none
            cell.lblCount.layer.cornerRadius = 25.0
            cell.lblCount.layer.borderColor = UIColor.white.cgColor
            cell.lblCount.layer.borderWidth = 2.0
            cell.lblCount.layer.masksToBounds = true
            
            cell.tf.tag = 101
            cell.tf.text = strTFCell1
            cell.tf.textColor = .white
            cell.tf.attributedPlaceholder = NSAttributedString(string: "@usuario", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString("ABC2D7")])
            cell.tf.delegate = self
            
            cell.btn.addTarget(self, action: #selector(self.btnCell1SAction), for: .touchUpInside)
            
            return cell
        }
        else if indexPath.row == 1
        {
            let cell:CellForgot_2 = tblView.dequeueReusableCell(withIdentifier: "CellForgot_2", for: indexPath) as! CellForgot_2
            cell.selectionStyle = .none
            cell.lblCount.layer.cornerRadius = 25.0
            cell.lblCount.layer.borderColor = UIColor.white.cgColor
            cell.lblCount.layer.borderWidth = 2.0
            cell.lblCount.layer.masksToBounds = true
            
            cell.tf.tag = 102
            cell.tf.text = strTFCell2
            cell.tf.textColor = .white
            cell.tf.attributedPlaceholder = NSAttributedString(string: "Código de Seguridad", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString("ABC2D7")])
            
            cell.tf.delegate = self
            
            return cell
        }
        else{
            
            let cell:CellForgot_3 = tblView.dequeueReusableCell(withIdentifier: "CellForgot_3", for: indexPath) as! CellForgot_3
            cell.selectionStyle = .none
            cell.lblCount.layer.cornerRadius = 25.0
            cell.lblCount.layer.borderColor = UIColor.white.cgColor
            cell.lblCount.layer.borderWidth = 2.0
            cell.lblCount.layer.masksToBounds = true
            
            cell.tf_1.tag = 103
            cell.tf_1.text = strTFCell3_1
            cell.tf_1.textColor = .white
            cell.tf_1.attributedPlaceholder = NSAttributedString(string: "Nueva Contraseña", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString("ABC2D7")])
            cell.tf_1.delegate = self
            
            cell.tf_2.tag = 104
            cell.tf_2.text = strTFCell3_2
            cell.tf_2.textColor = .white
            cell.tf_2.attributedPlaceholder = NSAttributedString(string: "Repite tu Contraseña", attributes: [NSAttributedString.Key.foregroundColor: UIColor.colorWithHexString("ABC2D7")])
            cell.tf_2.delegate = self
            
            cell.btn.addTarget(self, action: #selector(self.btnCell3SAction), for: .touchUpInside)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnCell1SAction()
    {
        if strTFCell1.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el nombre de usuario", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            self.view.endEditing(true)
            // call Api to send secutity code
            callGetSecurityCode()
        }
    }
    
    @objc func btnCell3SAction()
    {
        if strTFCell1.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el nombre de usuario", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else if strTFCell2.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese el código de seguridad recibido", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else if strTFCell3_1.isEmpty == true || strTFCell3_2.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese la nueva contraseña y repita la contraseña", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else if strTFCell3_1 != strTFCell3_2
        {
            self.showAlertWithTitle(title: "Alerta", message: "La contraseña nueva y la contraseña repetida no coinciden", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            // call Api to Submit new password
            self.view.endEditing(true)
            callSubmitForgotPassword()
        }
    }
}


extension ForgotPasswordVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 101
        {
            self.strTFCell1 = textField.text!
        }
        else if textField.tag == 102
        {
            self.strTFCell2 = textField.text!
        }
        else if textField.tag == 103
        {
            self.strTFCell3_1 = textField.text!
        }
        else if textField.tag == 104
        {
            self.strTFCell3_2 = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ForgotPasswordVC
{
    func callGetSecurityCode(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id":strTFCell1]
        
        WebService.requestService(url: ServiceName.GET_SecurityCodeForgotpssword, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //      print(jsonString)
            
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
                        if let _:String = json["response_object"] as? String
                        {
                            DispatchQueue.main.async {
                                
                                //                                {"internal_code":0,"message":"El código de seguridad fue enviado al correo electrónico personal registrado.","response_object":"8b6cc5df-161b-471a-8132-bb7d9862861e"}
                                
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                    return
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSubmitForgotPassword(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id":strTFCell1, "security_code":strTFCell2, "new_password":strTFCell3_2.md5Value]
        
        WebService.requestService(url: ServiceName.POST_Forgotpssword, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
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
                        if let _:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                // {"internal_code":0,"message":"El password fue actualizado exitosamente.","response_object":{}}
                                
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        self.dismiss(animated: true, completion: nil)
    }
}
