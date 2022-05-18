//
//  TabBarController_Ext2.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import Foundation
import UIKit

// SUPERVISOR TABS CODE

extension TabBarController
{
    func setupControllers_Supervisor()
    {
        let vc1 = AppStoryBoards.Profile.instance.instantiateViewController(identifier: "ProfileBaseVC_ID") as! ProfileBaseVC
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.isNavigationBarHidden = true

        let vc2 = AppStoryBoards.UserManage.instance.instantiateViewController(identifier: "UsersListVC_ID") as! UsersListVC
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.isNavigationBarHidden = true
        
        vcSuper3 = (AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "HomeSupervisorVC_ID") as! HomeSupervisorVC)
        let nav3 = UINavigationController(rootViewController: vcSuper3)
        nav3.isNavigationBarHidden = true

        let vc4 = AppStoryBoards.Announcement.instance.instantiateViewController(identifier: "AnnouncementVC_ID") as! AnnouncementVC
        let nav4 = UINavigationController(rootViewController: vc4)
        nav4.isNavigationBarHidden = true

        let vc5 = AppStoryBoards.Training.instance.instantiateViewController(identifier: "TrainingVC_ID") as! TrainingVC
        let nav5 = UINavigationController(rootViewController: vc5)
        nav5.isNavigationBarHidden = true

        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        setTabBarItems_Supervisor()
        
        selectedIndex = 2
    }

    func setTabBarItems_Supervisor(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "6UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "6Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = ""
        myTabBarItem1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "7UnSel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "7Sel")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
                myTabBarItem1.image = UIImage(named: "6UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem1.selectedImage = UIImage(named: "6Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem2.image = UIImage(named: "7UnSel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                myTabBarItem2.selectedImage = UIImage(named: "7Sel_r")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
            myTabBarItem1.image = UIImage(named: "6UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem1.selectedImage = UIImage(named: "6Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.image = UIImage(named: "7UnSel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem2.selectedImage = UIImage(named: "7Sel_s")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
        
        setupMiddleButton_Supervisor()
    }
    
    func setupMiddleButton_Supervisor() {
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

        middleButton.setImage(UIImage(named: "8Sel"), for: .normal)
        middleButton.addTarget(self, action: #selector(middleRaisedButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }    

}
