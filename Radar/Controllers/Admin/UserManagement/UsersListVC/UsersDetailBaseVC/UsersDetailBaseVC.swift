//
//  UsersDetailBaseVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class UsersDetailBaseVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTitleHeader:UILabel!
    @IBOutlet weak var collView:UICollectionView!
    @IBOutlet weak var imgV_User:UIImageView!
    @IBOutlet weak var vOnline:UIView!
    @IBOutlet weak var viewContainer:UIView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var isActiveStatus = false
    var strName = ""
    var strImgUser = ""
    var userUUIDselected = ""
    
    var arrCollView:[[String:Any]] = [["title":"DESEMPEÑO", "selected":true], ["title":"ZONAS", "selected":false], ["title":"ADMINISTRAR", "selected":false]]
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgV_User.layer.cornerRadius = 25.0
        imgV_User.layer.borderColor = k_baseColor.cgColor
        imgV_User.layer.borderWidth = 1.2
        imgV_User.layer.masksToBounds = true
        
        vOnline.layer.cornerRadius = 5.0
        vOnline.layer.masksToBounds = true

        vOnline.backgroundColor = UIColor(named: "AppRed")
        imgV_User.setImageUsingUrl(strImgUser)
        
        lblTitle.text = "Usuario"
        lblTitleHeader.text = strName
        
        if isActiveStatus == true
        {
            vOnline.backgroundColor = k_baseColor
        }
        
        setupConstraints()
       
        loadSubViewControllerAt(index:0)
        
        collView.delegate = self
        collView.dataSource = self
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

    func loadSubViewControllerAt(index:Int)
    {
        for views in viewContainer.subviews
        {
            views.removeFromSuperview()
        }
        
        if index == 0
        {
           // Tab 1  =  DESEMPEÑO
            let controller: PerformanceVC = AppStoryBoards.UserManage.instance.instantiateViewController(withIdentifier: "PerformanceVC_ID") as! PerformanceVC
            
            controller.userUUIDselected = self.userUUIDselected
            controller.view.frame = self.viewContainer.bounds;
            controller.willMove(toParent: self)
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 1
        {
            // Tab 2  =   ZONAS
            let controller: ZonesSupervisroVC = AppStoryBoards.UserManage.instance.instantiateViewController(withIdentifier: "ZonesSupervisroVC_ID") as! ZonesSupervisroVC
            controller.strName = self.strName
            controller.view.frame = self.viewContainer.bounds;
            controller.willMove(toParent: self)
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
        else if index == 2
        {
            // Tab 3  =  ADMINISTRAR
            let controller: AdminVC = AppStoryBoards.UserManage.instance.instantiateViewController(withIdentifier: "AdminVC_ID") as! AdminVC
            controller.isActiveStatus = self.isActiveStatus
            controller.view.frame = self.viewContainer.bounds;
            controller.willMove(toParent: self)
            self.viewContainer.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
        }
    }
}

extension UsersDetailBaseVC: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCellPerformanceDetail = collView.dequeueReusableCell(withReuseIdentifier: "CollCellPerformanceDetail", for: indexPath as IndexPath) as! CollCellPerformanceDetail
                
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

extension UsersDetailBaseVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = UIScreen.main.bounds.size.width - 30
        return CGSize(width: (collectionViewWidth/3), height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
