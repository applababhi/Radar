//
//  SalesforceVC.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class SalesforceVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var arrData:[[String:Any]] = []
    var zoneID = ""
    var zoneName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Vendedores Asignados"
        lblSubTitle.text = zoneName
        
        self.tblView.dataSource = self
        self.tblView.delegate = self
        imgBackground.setImageColor(color: UIColor.colorWithHexString("222629"))
        callGetList()
    }
    
    @IBAction func btnBackClick(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdduserClick(btn:UIButton)
    {
        callGetZoneSummary()
    }
}

extension SalesforceVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dic:[String:Any] = arrData[indexPath.row]
        let cell:CellSalesforce = tblView.dequeueReusableCell(withIdentifier: "CellSalesforce", for: indexPath) as! CellSalesforce
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblVisit.text = ""
        cell.lblPOS.text = ""
        cell.lblSales.text = ""
        cell.imgVUser.image = nil
        cell.imgVVisit.setImageColor(color: k_baseColor)
        cell.imgVSales.setImageColor(color: k_baseColor)
        cell.imgVPOS.setImageColor(color: k_baseColor)
        
        cell.imgVUser.layer.cornerRadius = 25.0
        cell.imgVUser.layer.borderColor = k_baseColor.cgColor
        cell.imgVUser.layer.borderWidth = 1.2
        cell.imgVUser.layer.masksToBounds = true
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteClick(btn:)), for: .touchUpInside)
        
        if let str:String = dic["low_picture_url"] as? String
        {
            cell.imgVUser.setImageUsingUrl(str)
        }
        if let str:String = dic["company_id"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dic["visits_count_str"] as? String
        {
            cell.lblVisit.text = str
        }
        if let str:String = dic["sales_count_str"] as? String
        {
            cell.lblSales.text = str
        }
        if let str:String = dic["pos_count_str"] as? String
        {
            cell.lblPOS.text = str
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnDeleteClick(btn:UIButton)
    {
        let dic:[String:Any] = arrData[btn.tag]
        if let strUUID:String = dic["uuid"] as? String
        {
            //
            let alertController = UIAlertController(title: "Radar", message: "¿Estás seguro de que deseas desasignar la zona de este usuario?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.callDisableUser(uuid: strUUID)
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel- ")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension SalesforceVC
{
    func callGetList(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "zone_id":zoneID]
        WebService.requestService(url: ServiceName.POST_PromotorPerformance, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
    
    func callDisableUser(uuid:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zoneID]
        WebService.requestService(url: ServiceName.GET_DisableUser, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            if let msg:String = json["message"] as? String
                            {
                                print(msg)
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Radar", message: "La zona se desasignó correctamente del usuario", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        self.callGetList()
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callGetZoneSummary(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_ZoneSummaryAssign, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arrperiod:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                let vc:AssignVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "AssignVC_ID") as! AssignVC
                                vc.arrPicker = arrperiod
                                vc.zone_id = self.zoneID
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
