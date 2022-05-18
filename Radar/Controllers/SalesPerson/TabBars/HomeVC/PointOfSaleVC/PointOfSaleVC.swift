//
//  PointOfSaleVC.swift
//  Radar
//
//  Created by Shalini Sharma on 3/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import CoreLocation

class PointOfSaleVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnNo:UIButton!
    @IBOutlet weak var btnYes:UIButton!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
    var userCurrentLocCord:CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    
    var reffHomeVC:HomeVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "¿Te encuentras actualmente en el punto de venta?"
        setupConstraints()
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
    
    @IBAction func btnNoClick(btn:UIButton){
        
        // In Next screen show section to search Address and once address searched, then show the list of suggested addresses radio button, and do not need to call "/zones/points/search"
        
        let vc:PointSaleDetailVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "PointSaleDetailVC_ID") as! PointSaleDetailVC
        vc.isLocationPresent = false
        vc.delegate = reffHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnYesClick(btn:UIButton){
        
        if userCurrentLocCord == nil
        {
            let alertController = UIAlertController(title: "Alerta", message: "Otorga permiso para la ubicación actual", preferredStyle:.alert)

            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            { action -> Void in
              
                self.locationManager.delegate = self
                self.locationManager.allowsBackgroundLocationUpdates = true
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.checkLocationEligibility()
            })
            alertController.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel)
            { action -> Void in
              // Put your code here
            })
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            // In Next detail screen, don't show section to search Address, rather after calling "actions/pos/validate", also call "/zones/points/search" on view load, to show sugegsted address radio button list
            
            let vc:PointSaleDetailVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "PointSaleDetailVC_ID") as! PointSaleDetailVC
            vc.userCurrentLocCord = self.userCurrentLocCord
            vc.isLocationPresent = true
            vc.delegate = reffHomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PointOfSaleVC: CLLocationManagerDelegate
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
            self.userCurrentLocCord = currentLocation.coordinate
            
            self.perform(#selector(self.stopLocationUpdate), with: nil, afterDelay: 4)
            
            print("Fetched Location Latitude \(self.userCurrentLocCord!.latitude)  : Longitude \(self.userCurrentLocCord!.longitude)")
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
        
        if userCurrentLocCord != nil
        {
            // In Next detail screen, don't show section to search Address, rather after calling "actions/pos/validate", also call "/zones/points/search" on view load, to show sugegsted address radio button list
            
            let vc:PointSaleDetailVC = AppStoryBoards.Home.instance.instantiateViewController(identifier: "PointSaleDetailVC_ID") as! PointSaleDetailVC
            vc.userCurrentLocCord = self.userCurrentLocCord
            vc.isLocationPresent = true
            vc.delegate = reffHomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PointOfSaleVC
{
     
}
