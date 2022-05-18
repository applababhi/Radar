//
//  POSVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class POSVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgV_Header:UIImageView!
    @IBOutlet weak var tblView:UITableView!
    
    var arrData:[[String:Any]] = []  // 2tf item + buscar arr Count
    var arrPicker_Zone:[[String:Any]] = []
    var arrPicker_Type:[[String:Any]] = []
    
    var pos_count_str = ""
    var strZone = ""
    var strType = ""
    
    var zone_id = ""
    var pos_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        lblTitle.text = pos_count_str + "  PDV Registrados"
        imgV_Header.setImageColor(color: k_baseColor)
        
        print(arrPicker_Type)
        print(pos_count_str)
        if arrPicker_Type.count > 0
        {
            let dictG:[String:Any] = arrPicker_Type.first!
            if let str:String = dictG["pos_type_str"] as? String
            {
                self.strType = str
            }
            if let str:Int = dictG["pos_type"] as? Int
            {
                self.pos_type = "\(str)"
            }
        }
        if arrPicker_Zone.count > 0
        {
            let dictG:[String:Any] = arrPicker_Zone.first!
            if let str:String = dictG["zone_name"] as? String
            {
                self.strZone = str
            }
            if let str:String = dictG["zone_id"] as? String
            {
                self.zone_id = str
            }
        }
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.reloadData()
    }
}

extension POSVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count + 1  // +1 is for first index for 2 tfs
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 170
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell:CellPos2Tf = tblView.dequeueReusableCell(withIdentifier: "CellPos2Tf", for: indexPath) as! CellPos2Tf
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.tfType.tag = 101
            cell.tfZone.tag = 102

            cell.tfType.text = ""
            cell.tfZone.text = ""
            cell.arrPicker_Type = arrPicker_Type
            cell.arrPicker_Zone = arrPicker_Zone
            cell.tfType.delegate = cell
            cell.tfZone.delegate = cell
            cell.addRightView(tf: cell.tfType)
            cell.addRightView(tf: cell.tfZone)
            
            cell.tfType.placeholder = "Mostrar por Tipo"
            cell.tfType.placeholderColor = .lightGray
            cell.tfType.borderActiveColor = k_baseColor
            cell.tfType.borderInactiveColor = .lightGray
            cell.tfType.placeholderFontScale = 1.0
            
            cell.tfZone.placeholder = "Zona"
            cell.tfZone.placeholderColor = .lightGray
            cell.tfZone.borderActiveColor = k_baseColor
            cell.tfZone.borderInactiveColor = .lightGray
            cell.tfZone.placeholderFontScale = 1.0
                    
            cell.tfZone.text = strZone
            cell.tfType.text = strType
                        
            cell.btn.addTarget(self, action: #selector(self.btnSearchClick(btn:)), for: .touchUpInside)
            
            cell.completion = { (dictG:[String:Any]?, strTF:String, index:Int) in
                
                if let str:String = dictG!["pos_type_str"] as? String
                {
                    self.strType = str
                }
                if let str:Int = dictG!["pos_type"] as? Int
                {
                    self.pos_type = "\(str)"
                }
                ///////
                if let str:String = dictG!["zone_name"] as? String
                {
                    self.strZone = str
                }
                if let str:String = dictG!["zone_id"] as? String
                {
                    self.zone_id = str
                }
                self.tblView.reloadData()
            }
            return cell
        }
        else
        {
            // returned search array
            let dic:[String:Any] = arrData[indexPath.row - 1]  // -1 because first index was tfs
            let cell:CellPosSupervisorList = tblView.dequeueReusableCell(withIdentifier: "CellPosSupervisorList", for: indexPath) as! CellPosSupervisorList
            cell.selectionStyle = .none
            cell.lblTitle.text = ""
            cell.lblSubTitle.text = ""
            
            if let str:String = dic["pos_name"] as? String
            {
                cell.lblTitle.text = str
            }
            
            if let str:String = dic["pos_type_str"] as? String
            {
                cell.lblSubTitle.text = str
            }

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnSearchClick(btn:UIButton)
    {
        if zone_id == "" || pos_type == ""
        {
            
        }
        else{
            // call Api
            callSearch()
        }
    }
}

extension POSVC
{
    func callSearch(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "zone_id":zone_id, "pos_type":pos_type]
        
        WebService.requestService(url: ServiceName.POST_SearchPosZones, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrData = arr
                            
                            DispatchQueue.main.async {
                                if arr.count == 0
                                {
                                    if let msg:String = json["message"] as? String
                                    {
                                        print("Count Zero - - ", msg)
                                        self.showAlertWithTitle(title: "Radar", message: "No se encontraron registros", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                    }
                                }
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
