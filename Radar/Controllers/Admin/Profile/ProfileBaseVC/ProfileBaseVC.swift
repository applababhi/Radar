//
//  ProfileBaseVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class ProfileBaseVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnUser:UIButton!
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    @IBOutlet weak var viewContainer:UIView!
    @IBOutlet weak var collView:UICollectionView!
    
    var dictMain:[String:Any] = [:]
    var arrCollView:[[String:Any]] = [["title":"USUARIOS", "selected":true], ["title":"PUNTOS DE VENTA", "selected":false], ["title":"VENTAS", "selected":false]]
    
    let imgVTemp_UserImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "@ABCD1234"
        
        btnUser.setImage(UIImage(named: "userPH"), for: .normal)
        btnUser.layer.cornerRadius = 22.5
        btnUser.layer.borderWidth = 1.5
        btnUser.layer.borderColor = k_baseColor.cgColor
        btnUser.layer.masksToBounds = true
        setupConstraints()
        
        setupData()
        
        collView.delegate = self
        collView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetProfile()
    }
    
    func setupData()
    {
        //        print(k_helper.baseGlobalDict)
        if let notfD:[String:Any] = k_helper.baseGlobalDict["notifications"] as? [String:Any]
        {
            
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
    
    @IBAction func btnLogoutClick(btn:UIButton){
        
        let alertController = UIAlertController(title: "Radar", message: "Estas seguro que quieres cerrar sesión", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
            UIAlertAction in
            k_userDef.setValue("", forKey: userDefaultKeys.uuid.rawValue)
            k_userDef.setValue("", forKey: userDefaultKeys.user_type.rawValue)
            k_userDef.setValue("", forKey: userDefaultKeys.plan.rawValue)
            k_userDef.synchronize()
            
            let vc: FirstVC = AppStoryBoards.Main.instance.instantiateViewController(withIdentifier: "FirstVC_ID") as! FirstVC
            k_window.rootViewController = vc
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel- ")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
        
    @IBAction func btnUserClick(btn:UIButton){
        let vc:EditProfileVC = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "EditProfileVC_ID") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadSubViewControllerAt(index:Int)
    {
        for views in viewContainer.subviews
        {
            views.removeFromSuperview()
        }
        
        if index == 0
        {
            // Tab 1  =  User Profile
            let controller: UsersVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "UsersVC_ID") as! UsersVC
            
            controller.view.frame = self.viewContainer.bounds;
            controller.willMove(toParent: self)
            if let users_count_str:String = self.dictMain["users_count_str"] as? String
            {
                controller.userCount = users_count_str
            }
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 1
        {
            // Tab 2  =   POS
            let controller: POSVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "POSVC_ID") as! POSVC
            
            controller.view.frame = self.viewContainer.bounds;
            
            if let arr:[[String:Any]] = self.dictMain["available_zones"] as? [[String:Any]]
            {
                controller.arrPicker_Zone = arr
            }
            if let arr:[[String:Any]] = self.dictMain["pos_types"] as? [[String:Any]]
            {
                controller.arrPicker_Type = arr
            }
            if let srt:String = self.dictMain["pos_count_str"] as? String
            {
                controller.pos_count_str = srt
            }
            controller.willMove(toParent: self)
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 2
        {
            // Tab 3  =  SALES
            let controller: SalesVC = AppStoryBoards.Profile.instance.instantiateViewController(withIdentifier: "SalesVC_ID") as! SalesVC
            controller.view.frame = self.viewContainer.bounds;
            if let arr:[[String:Any]] = self.dictMain["available_periods"] as? [[String:Any]]
            {
                controller.arrPicker = arr
            }
            controller.willMove(toParent: self)
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
    }
}

extension ProfileBaseVC: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCellPerformanceDetail = collView.dequeueReusableCell(withReuseIdentifier: "CollCellPerformanceDetail", for: indexPath as IndexPath) as! CollCellPerformanceDetail
        
        cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 17)
        if indexPath.item == 1
        {
          //  print(UIScreen.main.bounds.size.height)
            
           // cell.lblTitle.font = UIFont(name: CustomFont.regular, size: 15)
        }
        
        cell.lblTitle.text = ""
        cell.lblTitle.textColor = UIColor(named: "AppDarkBackground")
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        
        if let check:Bool = dict["selected"] as? Bool
        {
            if check == true
            {
                cell.lblTitle.textColor = UIColor(named: "AppGreenBlue")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // set the Base Controller
        
        var dict:[String:Any] = arrCollView[indexPath.item]
        
        if let check:Bool = dict["selected"] as? Bool
        {
            if check == true
            {
                return
            }
            else
            {
                for ind in 0..<arrCollView.count
                {
                    var dictInner:[String:Any] = arrCollView[ind]
                    dictInner["selected"] = false
                    arrCollView[ind] = dictInner
                }
                
                dict["selected"] = true
                arrCollView[indexPath.item] = dict
            }
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // to make cell in ceter on Tap
        collectionView.reloadData()
        loadSubViewControllerAt(index: indexPath.item)
    }
}

extension ProfileBaseVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0
        {
            // Left item
            let collectionViewWidth = UIScreen.main.bounds.size.width - 30
            return CGSize(width: (collectionViewWidth/3) - 25, height: 45)
        }
        else if indexPath.item == 1
        {
            // middle item
            let collectionViewWidth = UIScreen.main.bounds.size.width - 30
            return CGSize(width: (collectionViewWidth/3) + 50, height: 45)
        }
        else
        {
            // last item = right
            let collectionViewWidth = UIScreen.main.bounds.size.width - 30
            return CGSize(width: (collectionViewWidth/3) - 25, height: 45)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension ProfileBaseVC
{
    func callGetProfile(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        WebService.requestService(url: ServiceName.GET_ProfileBase, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let di:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.dictMain = di
                            DispatchQueue.main.async {
                                self.loadSubViewControllerAt(index:0)
                            }
                        }
                    }
                }
            }
        }
    }
}
