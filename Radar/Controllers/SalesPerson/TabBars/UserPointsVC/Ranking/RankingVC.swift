//
//  RankingVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class RankingVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = [["type":"picker", "ph":"Mes a Mostrar", "value":[:], "string":"", "height":140.0],
                                  ["type":"userinfo", "image":"", "name":"@abcd1234", "points":"1902", "height":60.0],
                                  ["type":"userinfo", "image":"", "name":"@qwerty984", "points":"1000", "height":60.0],
                                  ["type":"userinfo", "image":"", "name":"@xyz9988", "points":"790", "height":60.0],
                                  ["type":"collview", "array":[["number":1, "name":"abcd", "points":"123"], ["number":2, "name":"xyz", "points":"333"], ["number":3, "name":"rar", "points":"54"], ["number":4, "name":"zap", "points":"443"]], "height":"arraycount*50"]]
        
    var arrPicker:[[String:Any]] = []
    var titleBoard = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Ranking"
        setupConstraints()
       
        tblView.delegate = self
        tblView.dataSource = self
        
        callLeaderboardPeriod()
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

extension RankingVC: UITableViewDataSource, UITableViewDelegate
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
        else{
            if let arrCollV:[[String:Any]] = d["array"] as? [[String:Any]]{
                return CGFloat(arrCollV.count * 55)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            
            if strType == "picker"{
                let cell:CellRanking_Header = tblView.dequeueReusableCell(withIdentifier: "CellRanking_Header", for: indexPath) as! CellRanking_Header
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.tfDropDown.text = ""
                cell.lblTitle.text = ""
                cell.arrPicker = self.arrPicker
                cell.tfDropDown.delegate = cell
                cell.addRightView(imageName: "dropDown")
                
                cell.tfDropDown.placeholderColor = .lightGray
                cell.tfDropDown.borderActiveColor = k_baseColor
                cell.tfDropDown.borderInactiveColor = .lightGray
                cell.tfDropDown.placeholderFontScale = 1.0
                
                if let strph:String = dict["ph"] as? String
                {
                    cell.tfDropDown.placeholder = strph
                }
                if let str:String = dict["string"] as? String
                {
                    cell.tfDropDown.text = str
                }
                
                cell.lblTitle.text = titleBoard
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = d
                    if let str:String = d["month_name"] as? String
                    {
                        dict["string"] = str
                    }
                    if let str:String = d["month_id"] as? String
                    {
                        self.callLeaderboardUsers(period_id: str)
                    }
                    self.arrData[index] = dict
                }
                return cell

            }
            else if strType == "userinfo"{
                let cell:CellRanking_UserInfo = tblView.dequeueReusableCell(withIdentifier: "CellRanking_UserInfo", for: indexPath) as! CellRanking_UserInfo
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.lblPoints.text = ""
                
                cell.imgView.backgroundColor = .yellow
                cell.imgView.layer.cornerRadius = 23.0
                cell.imgView.layer.masksToBounds = true
                
                if let str:String = dict["name"] as? String
                {
                    cell.lblTitle.text = str
                }
                if let str:String = dict["points"] as? String
                {
                    cell.lblPoints.text = str
                }
                if let str:String = dict["image"] as? String
                {
                    cell.imgView.setImageUsingUrl(str)
                }
                
                return cell
            }
            else {
                // collection view
                let cell:CellRanking_CollView = tblView.dequeueReusableCell(withIdentifier: "CellRanking_CollView", for: indexPath) as! CellRanking_CollView
                cell.selectionStyle = .none
                
                if let arrCollV:[[String:Any]] = dict["array"] as? [[String:Any]]{
                    cell.arrCollView = arrCollV
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension RankingVC
{
    func callLeaderboardPeriod(){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        WebService.requestService(url: ServiceName.GET_LeaderboardPeriods, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            self.arrPicker = arr
                            
                            if arr.count > 0
                            {
                                var dMain:[String:Any] = self.arrData[0]
                                let dictU:[String:Any] = arr.first!
                                dMain["value"] = dictU
                                if let str:String = dictU["month_name"] as? String
                                {
                                    dMain["string"] = str
                                }
                                if let str:String = dictU["month_id"] as? String
                                {
                                    self.callLeaderboardUsers(period_id: str)
                                }
                                
                                self.arrData[0] = dMain
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callLeaderboardUsers(period_id:String){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "period_id":period_id]
        
        WebService.requestService(url: ServiceName.GET_LeaderboardUsers, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            // Create full arrData again, first index is dropdown and last index is collView, in middle all Users
                                                        
                            if let str:String = dJson["title"] as? String
                            {
                                self.titleBoard = str
                            }
                            
                            let dictFirstIndexMain:[String:Any] = self.arrData.first!
                            self.arrData.removeAll()
                            
                            if let arr:[[String:Any]] = dJson["podium"] as? [[String:Any]]
                            {
                                for d in arr{
                                    var dictNew:[String:Any] = ["type":"userinfo", "image":"", "name":"", "points":"", "height":60.0]
                                    if let str:String = d["picture_url"] as? String{
                                        dictNew["image"] = str
                                    }
                                    if let str:String = d["full_name"] as? String{
                                        dictNew["name"] = str
                                    }
                                    if let str:String = d["accumulated_points_str"] as? String{
                                        dictNew["points"] = str
                                    }
                                    self.arrData.append(dictNew)
                                }
                                self.arrData.insert(dictFirstIndexMain, at: 0)
                            }
                            
                            if let arr:[[String:Any]] = dJson["all_users"] as? [[String:Any]]
                            {
                                self.arrData.append(["type":"collview", "array":arr, "height":"arraycount*50"])
                            }
                                                        
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
