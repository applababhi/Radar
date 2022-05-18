//
//  TrainingVC.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class TrainingVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Cursos"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
        setupConstraints()
        
        setupData()
    }
    
    func setupData()
    {
        arrData = []
        
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
        
        if let arrCours:[[String:Any]] = k_helper.baseGlobalDict["courses"] as? [[String:Any]]
        {
            self.arrData = arrCours
          
            tblView.delegate = self
            tblView.dataSource = self
            tblView.reloadData()
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
}

extension TrainingVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        let cell:CellTrainingList = tblView.dequeueReusableCell(withIdentifier: "CellTrainingList", for: indexPath) as! CellTrainingList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        
        if let strTitle:String = dict["title"] as? String{
            cell.lblTitle.text = strTitle
        }
        
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(self.btnEnterClick(btn:)), for: .touchUpInside)

        if let img:String = dict["cover_url"] as? String
        {
            cell.imgCover.setImageUsingUrl(img)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnEnterClick(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        
        if let strTitle:String = dict["title"] as? String{
            if let course:String = dict["course_id"] as? String{
                callDetailWithCorseId(courseID: course, title: strTitle)
            }
        }
    }
}

extension TrainingVC
{
    func callDetailWithCorseId(courseID:String, title:String)
    {
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["course_id":courseID]
        WebService.requestService(url: ServiceName.GET_EnterListDetail, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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

                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                let vc: EntListDetailVC = AppStoryBoards.Entertainment.instance.instantiateViewController(withIdentifier: "EntListDetailVC_ID") as! EntListDetailVC
                                vc.strTitle = title
                                vc.dictMain = dict
                                vc.reffTrainVC = self
                                vc.strCourseID = courseID
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension TrainingVC: updateRootVCWithRewardsPopUpDelegate
{
    func showPopUp(title: String, desc: String, points: String) {
        let tabVC:TabBarController = self.tabBarController as! TabBarController
        tabVC.showRewardPopUp(title: title, subTitle: desc, points: points, vc:self)
    }
}
