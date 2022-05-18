//
//  InvitationCodeVC.swift
//  Radar
//
//  Created by Shalini Sharma on 12/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class InvitationCodeVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCode:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var vieCode:UIView!
    @IBOutlet weak var btnCopy:UIButton!
    @IBOutlet weak var btnShare:UIButton!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var isInviteSupervisor = false
    var isGenerateSecurityCode = false
    var strCode = ""
    var share_content = ""
    
    var strTitle = "Código de Acceso"
            
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = strTitle
        lblCode.text = ""
        lblDescription.text = ""
        vieCode.layer.cornerRadius = 5.0
        vieCode.layer.borderColor = k_baseColor.cgColor
        vieCode.layer.borderWidth = 1.2
        vieCode.layer.masksToBounds = true
        
        btnShare.layer.cornerRadius = 5.0
        btnShare.layer.masksToBounds = true
        btnCopy.layer.cornerRadius = 5.0
        btnCopy.layer.masksToBounds = true
        
        setupConstraints()
       
        if isGenerateSecurityCode == true{
            callGenerateSecurityCode()
        }
        else
        {
            callGetCode()
        }
    }
    
    func setupConstraints()
    {
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {
            c_ArcView_Ht.constant = 130
            c_LblTitle_Top.constant = 60
        }
        else if strModel == "iPhone Max"
        {
            c_ArcView_Ht.constant = 160
            c_LblTitle_Top.constant = 70
        }
        else if strModel == "iPhone 6+"
        {
            c_LblTitle_Top.constant = 45
        }
        else if strModel == "iPhone 6"
        {
            c_ArcView_Ht.constant = 95
        }
        else if strModel == "iPhone 5"
        {

        }
        else if strModel == "iPhone XR"
        {

        }
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCopyClick(btn:UIButton){
        UIPasteboard.general.string = strCode
    }
    
    @IBAction func btnShareClick(btn:UIButton){
        // set up activity view controller
        let textToShare = [ share_content ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // exclude some activity types from the list (optional)
      //  activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension InvitationCodeVC
{
    func callGetCode(){
        
        var campaign_id = ""
        if let userD:[String:Any] = k_helper.baseGlobalDict["user_information"] as? [String:Any]
        {
            if let id:String = userD["campaign_id"] as? String
            {
                campaign_id = id
            }
        }
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        var param: [String:Any] = [:]
        var serviceUrl = ""
        
        if isInviteSupervisor == true
        {
            param = ["campaign_id":campaign_id]
            serviceUrl = ServiceName.PUT_InvitationCode_Supervisor
        }
        else
        {
            param = ["uuid":uuid]
            serviceUrl = ServiceName.PUT_InvitationCode
        }
        
        WebService.requestService(url: serviceUrl, method: .put, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                if let str:String = dJson["code"] as? String
                                {
                                    self.lblCode.text = str
                                    self.strCode = str
                                }
                                if let str:String = dJson["message"] as? String
                                {
                                    self.lblDescription.text = str
                                }
                                if let str:String = dJson["share_content"] as? String
                                {
                                    self.share_content = str
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func callGenerateSecurityCode(){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:] // ["uuid":uuid]
        let serviceUrl = ServiceName.GET_GenerateSecurityCode
        
        WebService.requestService(url: serviceUrl + "?uuid=\(uuid)", method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
            print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                DispatchQueue.main.async {
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                return
                }
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
                            DispatchQueue.main.async {
                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.back))
                            return
                            }
                        }
                    }
                    else
                    {
                        // Pass
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                if let str:String = dJson["code"] as? String
                                {
                                    self.lblCode.text = str
                                    self.strCode = str
                                }
                                if let str:String = dJson["message"] as? String
                                {
                                    self.lblDescription.text = str
                                }
                                if let str:String = dJson["share_content"] as? String
                                {
                                    self.share_content = str
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}

