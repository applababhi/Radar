//
//  AvailableZoneDetailVC.swift
//  Radar
//
//  Created by Shalini Sharma on 6/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class AvailableZoneDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnHeaderTitle:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var dictMain:[String:Any] = [:]
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Zona Disposibles"
        btnHeaderTitle.setTitle("", for: .normal)
        
        setupConstraints()
        
        tblView.delegate = self
        tblView.dataSource = self
        setupData()
    }
    
    func setupData()
    {
        if let str:String = dictMain["results_message"] as? String
        {
            btnHeaderTitle.setTitle(str, for: .normal)
        }
        if let arr:[[String:Any]] = dictMain["results"] as? [[String:Any]]
        {
            arrData = arr
        }
        tblView.reloadData()
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

extension AvailableZoneDetailVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dic:[String:Any] = arrData[indexPath.row]
        let cell:CellZoneDetailList = tblView.dequeueReusableCell(withIdentifier: "CellZoneDetailList", for: indexPath) as! CellZoneDetailList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubTitle.text = ""
        cell.lblCount.text = ""
        cell.vCircle_1.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_2.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_3.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_4.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_5.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_6.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_7.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_8.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_9.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.vCircle_10.backgroundColor = UIColor(named: "AppDarkBackground")
        cell.imgV_Level.image = UIImage(named: "level_0")
        cell.imgV_User.image = UIImage(named: "zoneUserBlue")
        
        cell.vCircle_1.layer.cornerRadius = 5.0
        cell.vCircle_2.layer.cornerRadius = 5.0
        cell.vCircle_3.layer.cornerRadius = 5.0
        cell.vCircle_4.layer.cornerRadius = 5.0
        cell.vCircle_5.layer.cornerRadius = 5.0
        cell.vCircle_6.layer.cornerRadius = 5.0
        cell.vCircle_7.layer.cornerRadius = 5.0
        cell.vCircle_8.layer.cornerRadius = 5.0
        cell.vCircle_9.layer.cornerRadius = 5.0
        cell.vCircle_10.layer.cornerRadius = 5.0
                
        if let str:String = dic["zone_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dic["zone_id"] as? String
        {
            cell.lblSubTitle.text = str
        }
        if let count:Int = dic["promoters_count"] as? Int
        {
            cell.lblCount.text = "\(count)"
            
            if count == 0
            {
                cell.imgV_User.image = UIImage(named: "zoneUserGray")
            }
        }
        if let level:Int = dic["overall_biz_level"] as? Int
        {
            if level == 0
            {
                cell.imgV_Level.image = UIImage(named: "level_0")
            }
            else if level == 1
            {
                cell.imgV_Level.image = UIImage(named: "level_1")
            }
            else if level == 2
            {
                cell.imgV_Level.image = UIImage(named: "level_2")
            }
            else if level == 3
            {
                cell.imgV_Level.image = UIImage(named: "level_3")
            }
        }
        if let level:Int = dic["observed_biz_level"] as? Int
        {
            if level == 0
            {
                
            }
            else if level == 1
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 2
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 3
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 4
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 5
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 6
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_6.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 7
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_6.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_7.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 8
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_6.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_7.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_8.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 9
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_6.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_7.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_8.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_9.backgroundColor = UIColor(named: "AppBlue")
            }
            else if level == 10
            {
                cell.vCircle_1.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_2.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_3.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_4.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_5.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_6.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_7.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_8.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_9.backgroundColor = UIColor(named: "AppBlue")
                cell.vCircle_10.backgroundColor = UIColor(named: "AppBlue")
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic:[String:Any] = arrData[indexPath.row]
        if let str:String = dic["zone_id"] as? String
        {
            callZoneDetail(zone_id: str)
        }

    }
}

extension AvailableZoneDetailVC
{
    func callZoneDetail(zone_id:String){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id]
        
        WebService.requestService(url: ServiceName.POST_ZoneDetail, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: MapSupervisorVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "MapSupervisorVC_ID") as! MapSupervisorVC
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
