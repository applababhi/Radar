//
//  NotificationVC.swift
//  Radar
//
//  Created by Shalini Sharma on 19/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTitleHeader:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
            
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Notificaciones"
        lblTitleHeader.text = ""
        
        setupConstraints()
       
        tblView.delegate = self
        tblView.dataSource = self
        tblView.estimatedRowHeight = 10
        tblView.rowHeight = UITableView.automaticDimension
        
        callNotificationList()
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

extension NotificationVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let cell:CellNotificationList = tblView.dequeueReusableCell(withIdentifier: "CellNotificationList", for: indexPath) as! CellNotificationList
        cell.selectionStyle = .none
        cell.lblTitle.textAlignment = .left
        cell.lblDate.textAlignment = .left
        cell.lblTitle.text = ""
        cell.lblDate.text = ""
        cell.viewNotification.layer.cornerRadius = 5.0
        cell.viewNotification.layer.masksToBounds = true
        cell.viewNotification.backgroundColor = .clear
        
        if let str:String = dict["message"] as? String{
            cell.lblTitle.text = str
        }
        if let str:String = dict["date_str"] as? String{
            cell.lblDate.text = str
        }
        if let check:Bool = dict["is_unread"] as? Bool{
            if check == true
            {
                cell.viewNotification.backgroundColor = .red
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
}

extension NotificationVC
{    
    func callNotificationList(){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid]
        
        WebService.requestService(url: ServiceName.GET_NotificationList, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                            if let str:String = dJson["notifications_message"] as? String
                            {
                                self.lblTitleHeader.text = str
                            }
                            
                            if let arr:[[String:Any]] = dJson["notifications"] as? [[String:Any]]
                            {
                                self.arrData = arr
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
