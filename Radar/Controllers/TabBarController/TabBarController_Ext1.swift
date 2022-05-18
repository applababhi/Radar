//
//  TabBarController_Ext1.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import Foundation
import UIKit

// PROMOTOR TABS CODE

extension TabBarController
{    
    func setupControllers_Promotor()
    {
        let vc1 = AppStoryBoards.UserPoints.instance.instantiateViewController(identifier: "UserPointsVC_ID") as! UserPointsVC
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.isNavigationBarHidden = true

        let vc2 = AppStoryBoards.Zone.instance.instantiateViewController(identifier: "ZoneVC_ID") as! ZoneVC
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.isNavigationBarHidden = true
        
        vc3 = (AppStoryBoards.Home.instance.instantiateViewController(identifier: "HomeVC_ID") as! HomeVC)
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.isNavigationBarHidden = true

        let vc4 = AppStoryBoards.Announcement.instance.instantiateViewController(identifier: "AnnouncementVC_ID") as! AnnouncementVC
        let nav4 = UINavigationController(rootViewController: vc4)
        nav4.isNavigationBarHidden = true

        let vc5 = AppStoryBoards.Training.instance.instantiateViewController(identifier: "TrainingVC_ID") as! TrainingVC
        let nav5 = UINavigationController(rootViewController: vc5)
        nav5.isNavigationBarHidden = true

        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        setTabBarItems_Promotor()
        
        selectedIndex = 2
    }

    func setTabBarItems_Promotor(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "1UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "1Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = ""
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "2UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "2Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.title = ""
        myTabBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
      //  myTabBarItem3.image = UIImage(named: "3UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
     //   myTabBarItem3.selectedImage = UIImage(named: "3Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.title = ""
      //  myTabBarItem3.imageInsets = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)

        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "4UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "4Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.title = ""
        myTabBarItem4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "5UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "5Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.title = ""
        myTabBarItem5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let strModel = getDeviceModel()
        if strModel == "iPhone XS"
        {

        }
        else if strModel == "iPhone Max"
        {

            if UIScreen.main.nativeBounds.height == 1792
            {
                print("iphone 11 or XR")
                myTabBarItem1.image = UIImage(named: "1UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem1.selectedImage = UIImage(named: "1Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem2.image = UIImage(named: "2UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem2.selectedImage = UIImage(named: "2Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem4.image = UIImage(named: "4UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem4.selectedImage = UIImage(named: "4Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem5.image = UIImage(named: "5UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem5.selectedImage = UIImage(named: "5Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                myTabBarItem4.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                myTabBarItem5.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
        else if strModel == "iPhone 6+" || strModel == "iPhone 6" || strModel == "iPhone 5"
        {
            myTabBarItem1.image = UIImage(named: "1UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem1.selectedImage = UIImage(named: "1Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.image = UIImage(named: "2UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.selectedImage = UIImage(named: "2Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem4.image = UIImage(named: "4UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem4.selectedImage = UIImage(named: "4Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem5.image = UIImage(named: "5UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem5.selectedImage = UIImage(named: "5Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            myTabBarItem1.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            myTabBarItem2.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            myTabBarItem4.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            myTabBarItem5.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if strModel == "iPhone XR"
        {

        }
        
        setupMiddleButton_Promotor()
    }
    
    func setupMiddleButton_Promotor() {
        let strModel = getDeviceModel()

        if strModel == "iPhone 6+" || strModel == "iPhone 6" || strModel == "iPhone 5"
        {
            middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        }
        else
        {
            middleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        }

        var menuButtonFrame = middleButton.frame
        if strModel == "iPhone 6+" || strModel == "iPhone 6" || strModel == "iPhone 5"
        {
            menuButtonFrame.origin.y = view.bounds.height - (menuButtonFrame.height + 20)
        }
        else
        {
            menuButtonFrame.origin.y = view.bounds.height - (menuButtonFrame.height + 40)
        }
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        middleButton.frame = menuButtonFrame

        middleButton.backgroundColor = UIColor(named: "AppWhite")
        middleButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(middleButton)

        middleButton.setImage(UIImage(named: "3Sel"), for: .normal)
        middleButton.addTarget(self, action: #selector(middleRaisedButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }
    
    func loadVCSetUpDataWithClassName(vcClassName:String, vc:UIViewController)
    {
        if vcClassName == "HomeVC"
        {
            let vc:HomeVC = vc as! HomeVC
            vc.setupData()
        }
        else if vcClassName == "UserPointsVC"
        {
            let vc:UserPointsVC = vc as! UserPointsVC
            vc.setupData()
        }
        else if vcClassName == "ZoneVC"
        {
            let vc:ZoneVC = vc as! ZoneVC
            vc.setupData()
        }
        else if vcClassName == "TrainingVC"
        {
            let vc:TrainingVC = vc as! TrainingVC
            vc.setupData()
        }
        else if vcClassName == "AnnouncementVC"
        {
            let vc:AnnouncementVC = vc as! AnnouncementVC
            vc.setupData()
        }
        else if vcClassName == "HomeSupervisorVC"
        {
            let vc:HomeSupervisorVC = vc as! HomeSupervisorVC
            vc.setupData()
        }
        else if vcClassName == "UsersListVC"
        {
            let vc:UsersListVC = vc as! UsersListVC
            vc.setupData()
        }
        else if vcClassName == "ProfileBaseVC"
        {
            let vc:ProfileBaseVC = vc as! ProfileBaseVC
            vc.setupData()
        }
    }
}
