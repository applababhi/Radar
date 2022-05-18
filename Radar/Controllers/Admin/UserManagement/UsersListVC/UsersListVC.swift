//
//  UsersListVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class UsersListVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var tfSearch: HoshiTextField!
    @IBOutlet weak var btnNotification:UIButton!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
        
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Usuarios"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
        setupConstraints()
        
        tfSearch.placeholder = "Nombre de Usuario"
        tfSearch.placeholderColor = .lightGray
        tfSearch.borderActiveColor = k_baseColor
        tfSearch.borderInactiveColor = .lightGray
        tfSearch.placeholderFontScale = 1.0
        tfSearch.delegate = self
        
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    func setupData()
    {
        //        print(k_helper.baseGlobalDict)
        if let notfD:[String:Any] = k_helper.baseGlobalDict["notifications"] as? [String:Any]
        {
            if let check:Bool = notfD["has_unread_notifications"] as? Bool
            {
                if check == true
                {
                    btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
                }
                else
                {
                    btnNotification.setImage(UIImage(named: "notifyPlain"), for: .normal)
                }
            }
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
    
    @IBAction func btnNotificationClick(btn:UIButton){
       let vc:NotificationVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "NotificationVC_ID") as! NotificationVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBuscarClick(btn:UIButton){
        if tfSearch.text?.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el campo vacío", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSearchApiWith(company_id: tfSearch.text!)
        }
    }
    
    @IBAction func btnTodosClick(btn:UIButton){
        callSearchApiWith(company_id: "")
    }
}

extension UsersListVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UsersListVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let cell:CellUsermanageSearch = tblView.dequeueReusableCell(withIdentifier: "CellUsermanageSearch", for: indexPath) as! CellUsermanageSearch
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblCount.text = ""
        cell.viewStatus.layer.cornerRadius = 5.0
        cell.viewStatus.layer.masksToBounds = true
        cell.viewStatus.backgroundColor = UIColor(named: "AppRed")
        cell.imgV_User.layer.cornerRadius = 20.0
        cell.imgV_User.layer.borderWidth = 1.2
        cell.imgV_User.layer.borderColor = k_baseColor.cgColor
        cell.imgV_User.layer.masksToBounds = true
        cell.imgV_Location.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        
        if let str:String = dict["company_id"] as? String{
            cell.lblTitle.text = str
        }
        if let str:String = dict["zones_count_str"] as? String{
            cell.lblCount.text = str
        }
        if let str:String = dict["low_res_picture_url"] as? String
        {
            cell.imgV_User.setImageUsingUrl(str)
        }
        if let check:Bool = dict["active_status"] as? Bool{
            if check == true
            {
                cell.viewStatus.backgroundColor = UIColor(named: "AppBlue")
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        let controller: UsersDetailBaseVC = AppStoryBoards.UserManage.instance.instantiateViewController(withIdentifier: "UsersDetailBaseVC_ID") as! UsersDetailBaseVC
        if let str:String = dict["company_id"] as? String{
            controller.strName = str
        }
        if let str:String = dict["uuid"] as? String{
            controller.userUUIDselected = str
        }
        if let check:Bool = dict["active_status"] as? Bool{
            controller.isActiveStatus = check
        }
        if let str:String = dict["full_res_picture_url"] as? String{
            controller.strImgUser = str
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension UsersListVC
{
    func callSearchApiWith(company_id:String){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id":company_id]
        
        WebService.requestService(url: ServiceName.GET_UserManageSearch, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
}
