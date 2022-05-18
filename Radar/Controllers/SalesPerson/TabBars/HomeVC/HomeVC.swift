//
//  HomeVC.swift
//  Radar
//
//  Created by Shalini Sharma on 1/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNotification:UIButton!
    @IBOutlet weak var imgCircleVisit:UIImageView!
    @IBOutlet weak var imgCircleNew:UIImageView!
    @IBOutlet weak var imgCirclePuntos:UIImageView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    @IBOutlet weak var c_ViewVisit_Bottom:NSLayoutConstraint!
    @IBOutlet weak var c_ViewNew_Trailing:NSLayoutConstraint!
    @IBOutlet weak var c_ViewPunots_Top:NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var currentLocationCord: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = "Registrar Actividad"
        btnNotification.setImage(UIImage(named: "notifyBadge"), for: .normal)
                
        setupConstraints()
//        setImageViewColors() // no need to call as we updated image
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationEligibility()
        
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
        imgCircleVisit.setImageColor(color: k_baseColor)
        imgCircleNew.setImageColor(color: k_baseColor)
        imgCirclePuntos.setImageColor(color: k_baseColor)
        
        imgCircleVisit.layer.cornerRadius = 50.0
        imgCircleVisit.layer.borderWidth = 1.5
        imgCircleVisit.layer.borderColor = k_baseColor.cgColor
        imgCircleVisit.layer.masksToBounds = true
        
        imgCircleNew.layer.cornerRadius = 50.0
        imgCircleNew.layer.borderWidth = 1.5
        imgCircleNew.layer.borderColor = k_baseColor.cgColor
        imgCircleNew.layer.masksToBounds = true
        
        imgCirclePuntos.layer.cornerRadius = 50.0
        imgCirclePuntos.layer.borderWidth = 1.5
        imgCirclePuntos.layer.borderColor = k_baseColor.cgColor
        imgCirclePuntos.layer.masksToBounds = true
    }
    
    @IBAction func btnNotificationClick(btn:UIButton){
             let vc:NotificationVC = AppStoryBoards.Main.instance.instantiateViewController(identifier: "NotificationVC_ID") as! NotificationVC
             self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnVisitZoneClick(btn:UIButton){
        let vc:VisitZoneVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "VisitZoneVC_ID") as! VisitZoneVC
        vc.userCurrentLocCord = self.currentLocationCord
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnNewSaleClick(btn:UIButton){
        
        if currentLocationCord == nil
        {
            self.showAlertWithTitle(title: "Alerta", message: "Habilite sus servicios de ubicación para pasar a esta sección de la aplicación", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            let vc:NewSaleVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "NewSaleVC_ID") as! NewSaleVC
            vc.delegate = self
            vc.userCurrentLocCord = self.currentLocationCord
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnPointOfSaleClick(btn:UIButton){
        let vc:PointOfSaleVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "PointOfSaleVC_ID") as! PointOfSaleVC
        vc.userCurrentLocCord = self.currentLocationCord
        vc.reffHomeVC = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: updateRootVCWithRewardsPopUpDelegate
{
    func showPopUp(title: String, desc: String, points: String) {
        let tabVC:TabBarController = self.tabBarController as! TabBarController
        tabVC.showRewardPopUp(title: title, subTitle: desc, points: points, vc:self)
    }
}

extension HomeVC: CLLocationManagerDelegate
{
    func checkLocationEligibility()
    {
        let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        switch locationAuthorizationStatus
        {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization() // This is where you request permission to use location services
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled()
            {
                self.locationManager.startUpdatingLocation() // here you will start getting location
            }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        default:
            break
        }
    }
    
    // MARK: Location Delegate
    
    // Monitor location services authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        case .restricted, .denied:
            self.alertLocationAccessNeeded()
        default:
            break
        }
    }
    
    // Get the device's current location and assign the latest CLLocation value to your tracking variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = (locations.last ?? CLLocation()) as CLLocation
        
        if currentLocation != nil{
            self.currentLocationCord = currentLocation.coordinate
            
            self.perform(#selector(self.stopLocationUpdate), with: nil, afterDelay: 4)
            
            print("Fetched Location Latitude \(self.currentLocationCord!.latitude)  : Longitude \(self.currentLocationCord!.longitude)")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error - ", error.localizedDescription)
    }
    
    func alertLocationAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Location Access",
            message: "Location access is required for including the location of the hazard.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Location Access",
                                      style: .cancel,
                                      handler: { (alert) -> Void in
                                        UIApplication.shared.open(settingsAppURL,
                                                                  options: [:],
                                                                  completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func stopLocationUpdate()
    {
        locationManager.stopUpdatingLocation()
        print("Location Updates Stopped - - ")
    }
}
