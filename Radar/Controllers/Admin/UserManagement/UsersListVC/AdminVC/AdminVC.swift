//
//  AdminVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class AdminVC: UIViewController {

    @IBOutlet weak var lblTitle_1:UILabel!
    @IBOutlet weak var lblSubTitle_1:UILabel!
    @IBOutlet weak var btn_1:UIButton!
    
    @IBOutlet weak var lblTitle_2:UILabel!
    @IBOutlet weak var lblSubTitle_2:UILabel!
    @IBOutlet weak var btn_2:UIButton!
    
    var isActiveStatus = false
    var serviceLink = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn_1.layer.cornerRadius = 5.0
        btn_1.layer.masksToBounds = true
        btn_2.layer.cornerRadius = 5.0
        btn_2.layer.masksToBounds = true
        
        lblTitle_1.text = "Habilitar / Deshabilitar Usuario"
        lblSubTitle_1.text = "Su información no se perderá. El usuario únicamente perderá acceso a su cuenta."
        
        if isActiveStatus == true
        {
            btn_1.setTitle("Deshabilitar", for: .normal)
            serviceLink = ServiceName.PUT_DisableUser
            // u are enabled user, if u click its action then this ll disable user
        }
        else
        {
            btn_1.setTitle("Habilitar", for: .normal)
            // u are disabled user, if u click its action then this ll enable user
            serviceLink = ServiceName.PUT_EnableUser
        }
        
        lblTitle_2.text = "Generar Código de Seguridad"
        lblSubTitle_2.text = "Genera un código de seguridad para que este usuario pueda reestablecer su contraseña de forma segura."
        btn_2.setTitle("Generar", for: .normal)
    }

    @IBAction func btn1Ckick(btn:UIButton)
    {
        callEnableDisableUser()
    }
    
    @IBAction func btn2Ckick(btn:UIButton)
    {
        let vc: InvitationCodeVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "InvitationCodeVC_ID") as! InvitationCodeVC
        vc.isGenerateSecurityCode = true
        vc.strTitle = "Código de Seguridad"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AdminVC
{    
    func callEnableDisableUser(){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
       // print(param)
        WebService.requestService(url: serviceLink, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //  print(jsonString)
            
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
}
