//
//  Register1VC.swift
//  Radar
//
//  Created by Shalini Sharma on 29/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class Register1VC: UIViewController {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tfCode: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewBackgroundImage(name: "")
        hideKeyboardWhenTappedAround()
        
        lblNumber.layer.cornerRadius = 35.0
        lblNumber.layer.borderColor = UIColor.white.cgColor
        lblNumber.layer.borderWidth = 2.0
        lblNumber.layer.masksToBounds = true
        
        tfCode.placeholder = "Código (6 carácteres)"
        tfCode.placeholderColor = .lightGray
        tfCode.borderActiveColor = k_baseColor
        tfCode.borderInactiveColor = .lightGray
        tfCode.placeholderFontScale = 1.0
        
     //   tfCode.text = "GTX740"   // supervisor
//        tfCode.text = "Z2L57T" // promotor
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextClick(btn:UIButton){
        
        if !(tfCode.text!).isEmpty{
            callVerifyCode()
        }
        else{
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el código", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
}

extension Register1VC
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

extension Register1VC{
    
    func callVerifyCode(){
        
        //        var planId = ""
        //        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        //        {
        //            planId = id
        //        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code": tfCode.text!]
        
        WebService.requestService(url: ServiceName.GET_VerifyCode, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //   print(jsonString)
            
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
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let invtID:String = dict["invitation_code_id"] as? String{
                                if let userType:Int = dict["user_type"] as? Int{
                                    k_helper.tempRegisterDict["invitation_code_id"] = invtID
                                    
                                    DispatchQueue.main.async {
                                        let vc:Register2VC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "Register2VC_ID") as! Register2VC
                                        
//                                        if user_type == 1 , it's a Promotor else it's Supervisor
                                        
                                        if userType == 1{
                                            vc.arrData = [["type":"picker", "value":[:], "ph":"¿En qué Estado de la República vives?"], ["type":"picker", "value":[:], "ph":"¿A qué área reportas?"], ["type":"tf", "value":"", "ph":"Selecciona un nombre de usuario (Entre 6 y 20 caracteres)"], ["type":"password", "value":"", "ph":"Indica una contraseña de 6 o más caracteres"], ["type":"password", "value":"", "ph":"Por favor, repite tu contraseña"]]
                                        }
                                        else{
                                            vc.arrData = [["type":"picker", "value":[:], "ph":"¿En qué Estado de la República vives?"], ["type":"picker", "value":[:], "ph":"¿A qué área reportas?"], ["type":"tf", "value":"", "ph":"Selecciona un nombre de usuario (Entre 6 y 20 caracteres)"], ["type":"password", "value":"", "ph":"Indica una contraseña de 6 o más caracteres"], ["type":"password", "value":"", "ph":"Por favor, repite tu contraseña"], ["type":"tf", "value":"", "ph":"Por favor, Indica tu correo electrónico"], ["type":"mobile", "value":"", "ph":"Por favor, Indica tu número telefónico (10 digitos)"]]
                                        }
                                        
                                        vc.modalPresentationStyle = .overFullScreen
                                        vc.modalTransitionStyle = .crossDissolve
                                        self.present(vc, animated: true, completion: nil)
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
