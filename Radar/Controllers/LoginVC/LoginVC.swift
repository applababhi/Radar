//
//  LoginVC.swift
//  Radar
//
//  Created by Shalini Sharma on 29/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class LoginVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfUsername: HoshiTextField!
    @IBOutlet weak var tfPassword: HoshiTextField!
    
    var strTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strTitle

        self.setViewBackgroundImage(name: "")
        hideKeyboardWhenTappedAround()
        
        tfUsername.placeholder = "Nombre de Usuario"
        tfUsername.placeholderColor = .lightGray
        tfUsername.borderActiveColor = k_baseColor
        tfUsername.borderInactiveColor = .lightGray
        tfUsername.placeholderFontScale = 1.0
        
        tfPassword.placeholder = "Contraseña"
        tfPassword.placeholderColor = .lightGray
        tfPassword.borderActiveColor = k_baseColor
        tfPassword.borderInactiveColor = .lightGray
        tfPassword.placeholderFontScale = 1.0
        
      //  tfUsername.text = "jcespinosa"    // promotor
      //  tfPassword.text = "cleverflow"

     //   tfUsername.text = "autokrator10"    // SUPERVISOR
     //   tfPassword.text = "inspirum"
       // tfPassword.text = "cleverflow"
        
     //     tfUsername.text = "abhishek"    // SUPERVISOR
       //   tfPassword.text = "123456"
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPasswordClick(btn:UIButton){
        let vc:ForgotPasswordVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "ForgotPasswordVC_ID") as! ForgotPasswordVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
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
    
    @IBAction func btnLoginClick(btn:UIButton){
        
        if (tfUsername.text!).isEmpty == false && (tfPassword.text!).isEmpty == false {
            callPostToLoginUser()
        }
        else{
            self.showAlertWithTitle(title: "Alerta", message: "Ingrese texto en campos vacíos", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
    }
    
    @IBAction func btnRegisterClick(btn:UIButton){
        let vc:Register1VC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "Register1VC_ID") as! Register1VC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}

extension LoginVC
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

extension LoginVC
{
    func callPostToLoginUser()
    {
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id":tfUsername.text!, "password":tfPassword.text!.md5Value, "ios_notification_token":deviceToken_FCM, "ios_app_version":appVersion!]
        let urlStr:String = ServiceName.POST_LoginUser
      //  print(param)

        WebService.requestService(url: urlStr, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
           // print(jsonString)
            
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
                        if let baseDict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            // if user_type == 1 Then Load Promotor TabBar
                            // if user_type == 2 Then Load Supervisor TabBar
                            
                            DispatchQueue.main.async {
                                
                                if let userD:[String:Any] = baseDict["user_information"] as? [String:Any]
                                {
                                    if let userID:String = userD["uuid"] as? String
                                    {
                                        k_userDef.setValue(userID, forKey: userDefaultKeys.uuid.rawValue)
                                        k_userDef.synchronize()
                                    }
                                    
                                    if let user_type:Int = userD["user_type"] as? Int
                                    {
                                        k_userDef.setValue(user_type, forKey: userDefaultKeys.user_type.rawValue)
                                        k_userDef.synchronize()
                                        
                                        if user_type == 1
                                        {
                                            // Promotor
                                            userTypeString = "Promotor"
                                            let tabbar = AppStoryBoards.BaseTabBar.instance.instantiateViewController(identifier: "TabBarController_ID") as! TabBarController
                                            k_window.rootViewController = tabbar
                                        }
                                        else
                                        {
                                            // Supervisor
                                            userTypeString = "Supervisor"
                                            let tabbar = AppStoryBoards.BaseTabBar.instance.instantiateViewController(identifier: "TabBarController_ID") as! TabBarController
                                            k_window.rootViewController = tabbar
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
}
