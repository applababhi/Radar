//
//  ZoneVC.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class ZoneVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Mis Zonas Asignadas"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
        setupConstraints()
        
        tblView.dataSource = self
        tblView.delegate = self
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
        
        if let zoneD:[String:Any] = k_helper.baseGlobalDict["zones"] as? [String:Any]
        {
            if let arr:[[String:Any]] = zoneD["promoter_zones"] as? [[String:Any]]
            {
                print(arr)
                arrData = arr
            }
            if arrData.count > 0
            {
                tblView.reloadData()
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
    
    @IBAction func btnReloadTableClick(btn:UIButton){
        callRefreshZoneList()
    }
}

extension ZoneVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        let cell:CellZoneList = tblView.dequeueReusableCell(withIdentifier: "CellZoneList", for: indexPath) as! CellZoneList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        
        cell.viewIndicator1.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.viewIndicator1.layer.cornerRadius = 3.0
        cell.viewIndicator1.layer.masksToBounds = true
        cell.viewIndicator2.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.viewIndicator2.layer.cornerRadius = 3.0
        cell.viewIndicator2.layer.masksToBounds = true
        cell.viewIndicator3.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.viewIndicator3.layer.cornerRadius = 3.0
        cell.viewIndicator3.layer.masksToBounds = true
        
        cell.imgVUser1.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        cell.imgVUser2.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        cell.imgVUser3.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        cell.imgVUser4.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        cell.imgVUser5.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        cell.imgVUser6.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        
        if let strTitle:String = dict["zone_name"] as? String{
            cell.lblTitle.text = strTitle
        }
        if let strSubTitle:String = dict["zone_id"] as? String{
            cell.lblSubTitle.text = strSubTitle
        }
        
        if let indicator:Int = dict["overall_biz_level"] as? Int{
            
            if indicator == 1
            {
                cell.viewIndicator1.backgroundColor = k_baseColor
            }
            else if indicator == 2
            {
                cell.viewIndicator1.backgroundColor = k_baseColor
                cell.viewIndicator2.backgroundColor = k_baseColor
            }
            else if indicator == 3
            {
                cell.viewIndicator1.backgroundColor = k_baseColor
                cell.viewIndicator2.backgroundColor = k_baseColor
                cell.viewIndicator3.backgroundColor = k_baseColor
            }
        }
        
        if let users:Int = dict["user_visits_count"] as? Int{
            
            if users == 1
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
            }
            else if users == 2
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser2.setImageColor(color: UIColor(named: "AppBlue")!)
            }
            else if users == 3
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser2.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser3.setImageColor(color: UIColor(named: "AppBlue")!)
            }
            else if users == 4
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser2.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser3.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser4.setImageColor(color: UIColor(named: "AppBlue")!)
            }
            else if users == 5
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser2.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser3.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser4.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser5.setImageColor(color: UIColor(named: "AppBlue")!)
            }
            else if users == 6
            {
                cell.imgVUser1.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser2.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser3.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser4.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser5.setImageColor(color: UIColor(named: "AppBlue")!)
                cell.imgVUser6.setImageColor(color: UIColor(named: "AppBlue")!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        if let str:String = dict["zone_id"] as? String{
            callGetZoneSummary(zoneId: str)
        }
    }
}

extension ZoneVC
{
    func callRefreshZoneList(){
        
        var uuidId = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuidId = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid": uuidId]
        
        WebService.requestService(url: ServiceName.GET_ReloadZoneList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
    
    func callGetZoneSummary(zoneId:String){
        
        var uuidId = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuidId = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid": uuidId, "zone_id":zoneId]
        
        WebService.requestService(url: ServiceName.GET_ZoneSummary, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: ZoneSummaryVC = AppStoryBoards.Zone.instance.instantiateViewController(identifier: "ZoneSummaryVC_ID") as! ZoneSummaryVC
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
