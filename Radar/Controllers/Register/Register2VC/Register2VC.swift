//
//  Register2VC.swift
//  Radar
//
//  Created by Shalini Sharma on 29/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class Register2VC: UIViewController {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var arrData: [[String:Any]] = []
    
    var statePickerArr:[[String:Any]] = []
    var workplacePickerArr:[[String:Any]] = []
    
    var strPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewBackgroundImage(name: "")
        hideKeyboardWhenTappedAround()                
        
        callStatesListApi()
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextClick(btn:UIButton){
        
        if validateFields() == true
        {
          //  print(k_helper.tempRegisterDict)
            
            let vc:Register3VC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "Register3VC_ID") as! Register3VC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
    }
    
    func validateFields() -> Bool
    {
        for di in arrData
        {
            if let strValue:String = di["value"] as? String{
                
                if strValue == ""
                {
                    self.showAlertWithTitle(title: "Alerta", message: "Por favor llene los campos vacíos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                    return false
                }
                else
                {
                    if let strPH:String = di["ph"] as? String{
                        
                        if strPH == "Selecciona un nombre de usuario (Entre 6 y 20 caracteres)"{
                            
                            if strValue.count < 6 || strValue.count > 20
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "El nombre de usuario debe tener más de 6 caracteres y menos de 20 caracteres", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                            
                            if strValue.contains(" ")
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "El nombre de usuario no debe contener espacios", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                            
                            k_helper.tempRegisterDict["company_id"] = strValue
                        }
                                                
                        if strPH == "Indica una contraseña de 6 o más caracteres"{
                            if strValue.count < 6
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "La contraseña debe tener un mínimo de 6 caracteres", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                            self.strPassword = strValue
                        }
                        
                        if strPH == "Por favor, repite tu contraseña"{
                            if self.strPassword == strValue
                            {
                                k_helper.tempRegisterDict["password"] = strValue.md5Value
                            }
                            else
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "La contraseña no coincide", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                        }
                        
                        if strPH == "Por favor, Indica tu correo electrónico"{
                            if isValidEmail(testStr: strValue) == true
                            {
                                k_helper.tempRegisterDict["personal_mail_address"] = strValue
                            }
                            else
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "La identificación del correo electrónico no tiene el formato correcto", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                        }
                        
                        if strPH == "Por favor, Indica tu número telefónico (10 digitos)"{
                            if strValue.count != 10
                            {
                                self.showAlertWithTitle(title: "Alerta", message: "El número de teléfono debe tener 10 dígitos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                return false
                            }
                            k_helper.tempRegisterDict["phone_number"] = strValue
                        }
                    }
                }
            }
            
            if let dValue:[String:Any] = di["value"] as? [String:Any]{
                if dValue.count == 0{
                    self.showAlertWithTitle(title: "Alerta", message: "Por favor llene los campos vacíos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                    return false
                }
                else{
                    if let strPH:String = di["ph"] as? String{
                        
                        if strPH == "¿En qué Estado de la República vives?"{
                            // STATE
                            if let strValue:Int = dValue["id"] as? Int{
                                k_helper.tempRegisterDict["residence_state_id"] = strValue
                            }
                        }
                        else if strPH == "¿A qué área reportas?"{
                            // WORKPLACE
                            if let strValue:String = dValue["workplace_id"] as? String{
                                k_helper.tempRegisterDict["workplace_id"] = strValue
                            }
                        }
                    }
                }
            }
        }
        return true
    }
}

extension Register2VC
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

extension Register2VC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let di:[String:Any] = arrData[indexPath.row]
        
        let cell:CellRegister = tableView.dequeueReusableCell(withIdentifier: "CellRegister", for: indexPath) as! CellRegister
        cell.selectionStyle = .none
        cell.tf.delegate = cell
        cell.tf.text = ""
        cell.tf.placeholder = ""
        cell.tf.placeholderColor = .lightGray
        cell.tf.borderActiveColor = k_baseColor
        cell.tf.borderInactiveColor = .lightGray
        cell.tf.rightView = nil
        cell.tf.keyboardType = .default
        cell.tf.isSecureTextEntry = false
        cell.arrPicker = []
        cell.index = indexPath.row
        
        var strPH = ""
        
        if let str:String = di["ph"] as? String{
            strPH = str
            cell.tf.placeholder = strPH
        }
        
        if let strType:String = di["type"] as? String{
            if strType == "picker"
            {
                // Picker
                cell.addRightView()
                
                if strPH == "¿En qué Estado de la República vives?"{
                    // STATE
                    cell.pickerType = "State"
                    cell.arrPicker = self.statePickerArr
                }
                else if strPH == "¿A qué área reportas?"{
                    // WORKPLACE
                    cell.pickerType = "Workplace"
                    cell.arrPicker = self.workplacePickerArr
                }
            }
            else if strType == "password"
            {
                // Password
                cell.tf.isSecureTextEntry = true
            }
            else if strType == "mobile"
            {
                // Mobile
                cell.tf.keyboardType = .numberPad
            }
            else{
                // Regular
            }
        }
        
        
        if let strValue:String = di["value"] as? String{
            cell.tf.text = strValue  // filling normal TFs
        }
        
        if let dValue:[String:Any] = di["value"] as? [String:Any]{
            
            // filling picker TFs
            
            if strPH == "¿En qué Estado de la República vives?"{
                // STATE
                if let strValue:String = dValue["value"] as? String{
                    cell.tf.text = strValue
                }
                
            }
            else if strPH == "¿A qué área reportas?"{
                // WORKPLACE
                if let strValue:String = dValue["workplace_name"] as? String{
                    cell.tf.text = strValue
                }
            }
        }
        
        cell.completion = {(dict:[String:Any]?, strValue:String, index:Int) in
            
            if let strType:String = di["type"] as? String{
                if strType == "picker"
                {
                    var d:[String:Any] = self.arrData[index]
                    if dict != nil{
                        if dict!.count != 0{
                            d["value"] = dict!
                        }
                    }
                    self.arrData[index] = d
                }
                else{
                    var d:[String:Any] = self.arrData[index]
                    d["value"] = strValue
                    self.arrData[index] = d
                }
                self.tblView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){}
}

extension Register2VC{
    
    func callStatesListApi()
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["catalogue_id":"1"]
        
        WebService.requestService(url: ServiceName.GET_StatesList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //   print(jsonString)
            if error != nil
            {
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let valArr:[[String:Any]] = dict["values"] as? [[String:Any]]
                            {
                                self.statePickerArr = valArr
                                
                                if valArr.count > 0{
                                    self.arrData[0] = ["type":"picker", "value":valArr.first!, "ph":"¿En qué Estado de la República vives?"]
                                }
                                
                                self.callWorkplacesListApi()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callWorkplacesListApi()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        k_helper.tempRegisterDict["plan_id"] = plan_id
        
        WebService.requestService(url: ServiceName.GET_WorkplacesList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            //           print(jsonString)
            if error != nil
            {
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
                        
                        if let arrresp:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.workplacePickerArr = arrresp
                            
                            if arrresp.count > 0{
                                self.arrData[1] = ["type":"picker", "value":arrresp.first!, "ph":"¿A qué área reportas?"]
                            }
                        }
                        
                        DispatchQueue.main.async {
                            if self.tblView.delegate == nil
                            {
                                self.tblView.delegate = self
                                self.tblView.dataSource = self
                            }
                            
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
