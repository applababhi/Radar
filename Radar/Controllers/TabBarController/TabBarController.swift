//
//  TabBarController.swift
//  Radar
//
//  Created by Shalini Sharma on 29/7/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var middleButton:UIButton!
    var vc3:HomeVC!
    var vcSuper3:HomeSupervisorVC!
    var check_FirstTimeOnlyOnLoadTabBar:Bool = false
    let imgVTemp_UserImage = UIImageView()
    var customRewardView:CustomPopUpRewardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        callGlobalSummary(vc: nil)
        
        print("Tabbar ViewDidLoad Called - - - - - - - - - - -  - - - - - - - -   - -   -")
    }

    //MARK: TABBAR Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                
        if let nav:UINavigationController = viewController as? UINavigationController
        {
            callGlobalSummary(vc: nav.viewControllers.first!)
        }
        else if let homeVC:UIViewController = viewController as? UIViewController
        {
            callGlobalSummary(vc: homeVC)
        }
        
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 2
        {
            // It's Home VC
            
            if userTypeString == "Promotor"
            {
                middleButton.setImage(UIImage(named: "3Sel"), for: .normal)
                viewController.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                middleButton.setImage(UIImage(named: "8Sel"), for: .normal)
                viewController.navigationController?.popToRootViewController(animated: true)
            }
        }
        else
        {
            // for rest
            if userTypeString == "Promotor"
            {
                middleButton.setImage(UIImage(named: "3UnSel"), for: .normal)
            }
            else
            {
                middleButton.setImage(UIImage(named: "8UnSel"), for: .normal)
            }
        }
    }
}


extension TabBarController
{
    // MARK: - Lock Orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
    {
        return (isPad == true) ? .portrait : .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        print("--> iPAD Screen Orientation")
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }
}

extension TabBarController
{
    // MARK: - Middle Button Actions
    @objc func middleRaisedButtonAction(sender: UIButton) {
        selectedIndex = 2
        
        if userTypeString == "Promotor"
        {
            tabBarController(self, didSelect: vc3)
        }
        else
        {
            tabBarController(self, didSelect: vcSuper3)
        }
        
        print("Tabbar middle Raised Button Action - ")
    }

    // MARK: - Show PopUp Rewards on VC
    func showRewardPopUp(title:String, subTitle:String, points:String, vc:UIViewController)
    {
        if customRewardView != nil{
            customRewardView.removeFromSuperview()
            customRewardView = nil
        }
     
        customRewardView = CustomPopUpRewardView(frame: UIScreen.main.bounds)
        customRewardView.lblTitle.text = title
        customRewardView.lblSubTitle.text = subTitle
        
        customRewardView.lblPoints.text = "-"
        if points != ""
        {
            customRewardView.lblPoints.text = points
        }
        
        vc.view.addSubview(customRewardView)
        
        self.perform(#selector(self.removeCustomPopup), with: nil, afterDelay: 4.0)
    }
    
    @objc func removeCustomPopup()
    {
        customRewardView.removeFromSuperview()
        customRewardView = nil
    }
}


extension TabBarController
{
    func callGlobalSummary(vc:UIViewController?)
    {
        k_helper.baseGlobalDict = [:]
        
        var uuid_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid_id]
        let urlStr:String = ServiceName.POST_GlobalSummary

        WebService.requestService(url: urlStr, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let Dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                k_helper.baseGlobalDict = Dict
                                
                                if let userD:[String:Any] = k_helper.baseGlobalDict["user_information"] as? [String:Any]
                                {
                                    if let title:String = userD["profile_picture_url"] as? String
                                    {
                                        self.imgVTemp_UserImage.setImageUsingUrl(title)
                                        self.perform(#selector(self.updateUserPhoto), with: nil, afterDelay: 2.5)
                                    }
                                }
                                
                                if self.check_FirstTimeOnlyOnLoadTabBar == false
                                {
                                    self.check_FirstTimeOnlyOnLoadTabBar = true
                                    
                                    if userTypeString == "Promotor"
                                    {
                                        self.setupControllers_Promotor() // set to Home and rest VC for only one time
                                    }
                                    else
                                    {
                                        self.setupControllers_Supervisor()
                                    }
                                }
                                else
                                {
                                    // when user tap on tabs each time, we ll call that VC setup method
                                    
                                    if vc != nil
                                    {
                                        let vcClassName = vc!.className
                                        print("Class Name Tapped - - - >  > ", vcClassName)
                                        
                                        self.loadVCSetUpDataWithClassName(vcClassName: vcClassName, vc: vc!)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateUserPhoto(){
        k_helper.userImage = imgVTemp_UserImage.image!
    }
}
