//
//  UserPointsVC.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class UserPointsVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDiamonds:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var btnWallet:UIButton!
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    let imgVTemp_UserImage = UIImageView()
    
    var arrCollView:[[String:Any]] = []
    
    var arrData:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnWallet.isHidden = true
        lblTitle.text = ""
        lblDiamonds.text = ""
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
        btnUser.setImage(UIImage(named: "userPH"), for: .normal)
        btnUser.layer.cornerRadius = 22.5
        btnUser.layer.borderWidth = 1.5
        btnUser.layer.borderColor = k_baseColor.cgColor
        btnUser.layer.masksToBounds = true
        setupConstraints()
        
        tblView.estimatedRowHeight = 10
        tblView.rowHeight = UITableView.automaticDimension
        tblView.dataSource = self
        tblView.delegate = self
        
        collView.dataSource = self
        collView.delegate = self
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
        
        if let appInfoD:[String:Any] = k_helper.baseGlobalDict["app_information"] as? [String:Any]
        {
            if let check:Bool = appInfoD["display_wallet"] as? Bool
            {
                if check == true
                {
                    btnWallet.isHidden = false
                }
            }
        }
        
        if let userD:[String:Any] = k_helper.baseGlobalDict["user_information"] as? [String:Any]
        {
            if let title:String = userD["profile_picture_url"] as? String
            {
                if k_helper.userImage == nil
                {
                    imgVTemp_UserImage.setImageUsingUrl(title)
                    self.perform(#selector(self.updateUserPhoto), with: nil, afterDelay: 2.0)
                }
                else
                {
                    self.btnUser.setImage(k_helper.userImage!, for: .normal)
                }
                
            }
            
            if let title:String = userD["company_id"] as? String
            {
                lblTitle.text = title
            }
        }
        
        if let transactionD:[String:Any] = k_helper.baseGlobalDict["transactions"] as? [String:Any]
        {
            if let title:String = transactionD["total_tokens_str"] as? String
            {
                lblDiamonds.text = title
            }
            
            if let arr:[[String:Any]] = transactionD["transactions"] as? [[String:Any]]
            {
                arrData = arr
            }
            if arrData.count > 0
            {
                tblView.reloadData()
            }
            if let arr:[[String:Any]] = transactionD["available_periods"] as? [[String:Any]]
            {
                var arrT:[[String:Any]] = arr.reversed()
                
                for ind in 0..<arrT.count{
                    var d:[String:Any] = arrT[ind]
                    
                    if ind == arrT.count - 1   // make the last one as selected
                    {
                        d["selected"] = true
                    }
                    else
                    {
                        d["selected"] = false
                    }
                    arrT[ind] = d
                }
                arrCollView = arrT
            }
            if arrCollView.count > 0
            {
                collView.reloadData()
            }
        }
        
    }
    
    @objc func updateUserPhoto(){
        btnUser.setImage(imgVTemp_UserImage.image!, for: .normal)
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
    
    @IBAction func btnUserClick(btn:UIButton){
        let vc:EditProfileVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "EditProfileVC_ID") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRewardsClick(btn:UIButton){
        let vc:RecompensasListVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "RecompensasListVC_ID") as! RecompensasListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRankingClick(btn:UIButton){
        let vc:RankingVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "RankingVC_ID") as! RankingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserPointsVC: UITableViewDataSource, UITableViewDelegate
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
        
        let cell:CellUserPoints = tblView.dequeueReusableCell(withIdentifier: "CellUserPoints", for: indexPath) as! CellUserPoints
        cell.selectionStyle = .none
        cell.lblDesc.text = ""
        cell.lblDate.text = ""
        cell.lblPoints.text = ""
        
        if let strTitle:String = dict["transaction_date_str"] as? String{
            cell.lblDate.text = strTitle
        }
        if let strTitle:String = dict["description"] as? String{
            cell.lblDesc.text = strTitle
        }
        if let strTitle:String = dict["tokens_str"] as? String{
            cell.lblPoints.text = strTitle
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       // let dict:[String:Any] = arrData[indexPath.row]
    }
}

extension UserPointsVC: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCellUserPoint = collView.dequeueReusableCell(withReuseIdentifier: "CollCellUserPoint", for: indexPath as IndexPath) as! CollCellUserPoint
        
        cell.lblTitle.text = ""
        
        cell.lblTitle.layer.cornerRadius = 10.0
        cell.lblTitle.layer.masksToBounds = true
        
        cell.lblTitle.textColor = UIColor(named: "AppGray")
        cell.lblTitle.backgroundColor = .clear
        
        if let str:String = dict["period_name"] as? String
        {
            cell.lblTitle.text = str
        }
        if let check:Bool = dict["selected"] as? Bool
        {
            if check == true
            {
                cell.lblTitle.textColor = .white
                cell.lblTitle.backgroundColor = UIColor(named: "AppDarkBackground")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for index in 0..<arrCollView.count
        {
            var dict:[String:Any] = arrCollView[index]
            
            if index == indexPath.item
            {
                if let check:Bool = dict["selected"] as? Bool
                {
                    if check == true
                    {
                        // means u tapped on same cell again, so don't change it
                    }
                    else{
                        let localCheck:Bool = !check
                        dict["selected"] = localCheck
                        arrCollView[index] = dict
                    }
                }
            }
            else
            {
                dict["selected"] = false
                arrCollView[index] = dict
            }
        }
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        if let str:String = dict["period_id"] as? String
        {
            // call api then reload collv and tblview
            callGetTransactionsForPeriodId(id: str)
        }
    }
}

extension UserPointsVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: (collectionViewWidth/6.5), height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension UserPointsVC
{
    func callGetTransactionsForPeriodId(id:String)
    {
        self.arrData = []
        self.tblView.reloadData()
        self.collView.reloadData()
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "period_id":id]
        WebService.requestService(url: ServiceName.GET_EachMonthTransactionList, method: .get, parameters: param, headers: [:], encoding: "QueryString", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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

                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                if let title:String = d["total_tokens_str"] as? String
                                {
                                    self.lblDiamonds.text = title
                                }
                                
                                if let arr:[[String:Any]] = d["transactions"] as? [[String:Any]]
                                {
                                    self.arrData = arr
                                    self.tblView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
