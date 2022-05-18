//
//  POSsupervisorVC.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class POSsupervisorVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var arrData:[[String:Any]] = []
    var zoneID = ""
    var zoneName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        lblTitle.text = "Puntos de Venta"
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
        
    }
}

extension POSsupervisorVC: UITableViewDataSource, UITableViewDelegate
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
        let dic:[String:Any] = arrData[indexPath.row]
        let cell:CellPosSupervisor = tblView.dequeueReusableCell(withIdentifier: "CellPosSupervisor", for: indexPath) as! CellPosSupervisor
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        cell.lblCount.text = ""
        cell.imgV.setImageColor(color: k_baseColor)
        
        if let str:String = dic["pos_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dic["pos_type_str"] as? String
        {
            cell.lblSubTitle.text = str
        }
        if let str:String = dic["sales_count_str"] as? String
        {
            cell.lblCount.text = str
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnDeleteClick(btn:UIButton)
    {
    }
}

extension POSsupervisorVC
{
    func callGetList(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "zone_id":zoneID]
        WebService.requestService(url: ServiceName.GET_POSsupervisor, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
//            print(jsonString)
            
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
