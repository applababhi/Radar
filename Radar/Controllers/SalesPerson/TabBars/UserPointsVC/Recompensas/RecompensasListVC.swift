//
//  RecompensasListVC.swift
//  Radar
//
//  Created by Shalini Sharma on 4/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class RecompensasListVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Recompensas"
        setupConstraints()
       
        tblView.delegate = self
        tblView.dataSource = self
        callGGetWallet()
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

}

extension RecompensasListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]

        let cell:CellRecompensasList = tblView.dequeueReusableCell(withIdentifier: "CellRecompensasList", for: indexPath) as! CellRecompensasList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        cell.imgView.backgroundColor = .systemOrange
        cell.imgView.layer.cornerRadius = 30.0
        cell.imgView.layer.borderColor = UIColor.white.cgColor
        cell.imgView.layer.borderWidth = 1.5
        cell.imgView.layer.masksToBounds = true
                
        if let strTitle:String = dict["gift_name"] as? String{
            cell.lblTitle.text = strTitle
        }
        if let strSubTitle:String = dict["points_str"] as? String{
            cell.lblSubTitle.text = strSubTitle
        }
        if let str:String = dict["front_cover_url"] as? String
        {
            cell.imgView.setImageUsingUrl(str)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        if let isActive:Bool = dict["is_active"] as? Bool{
            if isActive == true
            {
                if let id:String = dict["code_id"] as? String{
                    self.callGGetWalletCode(codeId: id)
                }
            }
        }
    }
}

extension RecompensasListVC
{
    func callGGetWallet(){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        
        WebService.requestService(url: ServiceName.GET_GetWalletList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrData = arr
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func callGGetWalletCode(codeId:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["code_id":codeId]
        
        WebService.requestService(url: ServiceName.GET_GetWalletCode, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc:RecompensasDetailVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "RecompensasDetailVC_ID") as! RecompensasDetailVC
                                vc.dictMain = di
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
