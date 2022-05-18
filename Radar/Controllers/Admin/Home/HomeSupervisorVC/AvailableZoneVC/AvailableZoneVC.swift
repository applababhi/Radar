//
//  AvailableZoneVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class AvailableZoneVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnHeaderTitle:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrMainState:[[String:Any]] = []
    var arrData:[[String:Any]] = []  // create array  2 tf and 2 picker and search button
    var arrState:[String] = []
    var arrMuncipality:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Buscar Zonas"
        btnHeaderTitle.setTitle("", for: .normal)
        
        setupConstraints()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        callAvailableList()
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

extension AvailableZoneVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let d:[String:Any] = arrData[indexPath.row]
        if let height:Double = d["height"] as? Double{
            return CGFloat(height)
        }
        else if let _:String = d["height"] as? String{
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //    CellVisitZone_Submit
        
        var dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            
            if strType == "picker"{
                let cell:CellAvailableZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellAvailableZone_TF", for: indexPath) as! CellAvailableZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.tfPickers.text = ""
                cell.arrPicker = []
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "dropDown")
                
                cell.tfPickers.placeholder = ""
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let strPh:String = dict["ph"] as? String
                {
                    if strPh == "Estado"
                    {
                        // state
                        cell.arrPicker = self.arrState
                    }
                    else
                    {
                        // muncipality
                        cell.arrPicker = self.arrMuncipality
                    }
                    cell.tfPickers.placeholder = strPh
                }
                
                if let str:String = dict["value"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (strTF:String, index:Int) in
                    dict["value"] = strTF
                    
                    if let strPh:String = dict["ph"] as? String
                    {
                        if strPh == "Estado"
                        {
                            // if state changed, change also muncipality array
                            
                            for d in self.arrMainState
                            {
                                if let str:String = d["state_name"] as? String
                                {
                                    if str == strTF
                                    {
                                        if let ar:[String] = d["municipalities"] as? [String]
                                        {
                                            self.arrMuncipality = ar
                                            if ar.count > 0
                                            {
                                                let strMun:String = ar.first!
                                                self.arrData[index + 1] = ["type":"picker", "value":strMun, "ph":"Municipio", "height":70.0]
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else if strType == "tf"{
                let cell:CellAvailableZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellAvailableZone_TF", for: indexPath) as! CellAvailableZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.arrPicker = []
                cell.tfPickers.text = ""
                cell.tfPickers.delegate = cell
                cell.tfPickers.placeholder = ""
                
                if let str:String = dict["ph"] as? String
                {
                    cell.tfPickers.placeholder = str
                }
                
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let str:String = dict["value"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (strTF:String, index:Int) in
                    dict["value"] = strTF
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else
            {
                let cell:CellVisitZone_Submit = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Submit", for: indexPath) as! CellVisitZone_Submit
                cell.selectionStyle = .none
                cell.btnSubmit.layer.cornerRadius = 10.0
                cell.btnSubmit.layer.masksToBounds = true
                cell.btnSubmit.addTarget(self, action: #selector(self.btnSubmitClick(btn:)), for: .touchUpInside)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnSubmitClick(btn:UIButton)
    {
        print("Call Api to search")
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        var parameter:[String:Any] = ["plan_id":plan_id, "zone_id":"", "zone_name":"", "state_name":"","municipality_name":""]
        for ind in 0..<self.arrData.count
        {
            let d:[String:Any] = self.arrData[ind]
            if let str:String = d["value"] as? String
            {
                if ind == 0
                {
                    parameter["zone_id"] = str
                }
                else if ind == 1
                {
                    parameter["zone_name"] = str
                }
                else if ind == 2
                {
                    parameter["state_name"] = str
                }
                else if ind == 3
                {
                    parameter["municipality_name"] = str
                }
            }
        }
        
        callSearchApi(param: parameter)
    }
}

extension AvailableZoneVC
{
    func callAvailableList(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_AvailableZoneList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            if let str:String = dJson["count_str"] as? String
                            {
                                self.btnHeaderTitle.setTitle(str, for: .normal)
                            }
                            
                            DispatchQueue.main.async {
                                self.callStates()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func callStates(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_AvailableStates, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arrS:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrMainState = arrS
                            
                            for d in arrS
                            {
                                if let str:String = d["state_name"] as? String
                                {
                                    self.arrState.append(str)
                                }
                            }
                            
                            self.arrData.append(["type":"tf", "value":"", "ph":"ID de Zona", "height":70.0])
                            self.arrData.append(["type":"tf", "value":"", "ph":"Nombre de la de Zona", "height":70.0])
                            //
                            
                            if arrS.count > 0
                            {
                                let dic:[String:Any] = arrS.first!
                                
                                if let str:String = dic["state_name"] as? String
                                {
                                    self.arrData.append(["type":"picker", "value":str, "ph":"Estado", "height":70.0])
                                }
                                                                
                                if let ar:[String] = dic["municipalities"] as? [String]
                                {
                                    self.arrMuncipality = ar
                                    if ar.count > 0
                                    {
                                        let strMun:String = ar.first!
                                        self.arrData.append(["type":"picker", "value":strMun, "ph":"Municipio", "height":70.0])
                                    }
                                }
                            }
                            
                            self.arrData.append(["type":"submit", "height":35.0])
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSearchApi(param:[String:Any]){
        
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.requestService(url: ServiceName.POST_SearchZones, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                            let vc:AvailableZoneDetailVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "AvailableZoneDetailVC_ID") as! AvailableZoneDetailVC
                                vc.dictMain = dJson
                            self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
