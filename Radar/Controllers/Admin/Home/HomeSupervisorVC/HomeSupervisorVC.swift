//
//  HomeSupervisorVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class HomeSupervisorVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
  //  @IBOutlet weak var imgCircleVisit:UIImageView!
    @IBOutlet weak var imgCircleVisit_Circle:UIImageView!
    @IBOutlet weak var imgCircleNew:UIImageView!
    @IBOutlet weak var imgCirclePuntos:UIImageView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    @IBOutlet weak var c_ViewVisit_Bottom:NSLayoutConstraint!
    @IBOutlet weak var c_ViewNew_Trailing:NSLayoutConstraint!
    @IBOutlet weak var c_ViewPunots_Top:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HERE : imgCircleVisit = Available Zones.  imgCircleNew = Assign.  imgCirclePuntos = DownloadReport
        
        lblTitle.text = "Zonas"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
                
        setupConstraints()
        setImageViewColors()
                
        setupData()
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
            c_ViewVisit_Bottom.constant = 40
        }
        else if strModel == "iPhone Max"
        {
            c_ArcView_Ht.constant = 160
            c_LblTitle_Top.constant = 70
            c_ViewVisit_Bottom.constant = 50
            c_ViewNew_Trailing.constant = 60
            c_ViewPunots_Top.constant = 65
        }
        else if strModel == "iPhone 6+"
        {
            c_LblTitle_Top.constant = 45
            c_ViewVisit_Bottom.constant = 30
            c_ViewNew_Trailing.constant = 55
        }
        else if strModel == "iPhone 6"
        {
            c_ArcView_Ht.constant = 95
            c_ViewPunots_Top.constant = 45
        }
        else if strModel == "iPhone 5"
        {
            
        }
        else if strModel == "iPhone XR"
        {
            
        }
    }
    
    func setImageViewColors()
    {
      //  imgCircleVisit.setImageColor(color: k_baseColor)
      //  imgCircleNew.setImageColor(color: k_baseColor)
     //   imgCirclePuntos.setImageColor(color: k_baseColor)
        
//        imgCircleVisit_Circle.layer.cornerRadius = 50.0
//        imgCircleVisit_Circle.layer.borderWidth = 1.5
//        imgCircleVisit_Circle.layer.borderColor = k_baseColor.cgColor
//        imgCircleVisit_Circle.layer.masksToBounds = true
        
//        imgCircleNew.layer.cornerRadius = 50.0
//        imgCircleNew.layer.borderWidth = 1.5
//        imgCircleNew.layer.borderColor = k_baseColor.cgColor
//        imgCircleNew.layer.masksToBounds = true
//        
//        imgCirclePuntos.layer.cornerRadius = 50.0
//        imgCirclePuntos.layer.borderWidth = 1.5
//        imgCirclePuntos.layer.borderColor = k_baseColor.cgColor
//        imgCirclePuntos.layer.masksToBounds = true
    }
    
    @IBAction func btnNotificationClick(btn:UIButton){
             let vc:NotificationVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "NotificationVC_ID") as! NotificationVC
             self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAvailableZoneClick(btn:UIButton){
        let vc:AvailableZoneVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "AvailableZoneVC_ID") as! AvailableZoneVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAssignClick(btn:UIButton){
        callGetZoneSummary()
    }
    
    @IBAction func btnDownloadReportClick(btn:UIButton){
        let vc:DownloadReportsVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "DownloadReportsVC_ID") as! DownloadReportsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeSupervisorVC
{
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
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
