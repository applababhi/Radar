//
//  VisitZoneVC.swift
//  Radar
//
//  Created by Shalini Sharma on 2/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import CoreLocation

class VisitZoneVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var delegate:updateRootVCWithRewardsPopUpDelegate!
    
    let locationManager = CLLocationManager()
    var userCurrentLocCord:CLLocationCoordinate2D!
    
    var current_zone_index:Int!
    
    var arrData:[[String:Any]] = [["type":"picker", "value":[:], "string":"", "height":70.0], ["type":"date", "value":"", "height":70.0], ["type":"currentLocation", "value":"", "selected":false, "image":"location_off", "string":"", "height":105.0], ["type":"rewards", "description":"", "value":"", "height":115.0], ["type":"submit", "height":70.0]]
    
    var arrPicker:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate:String = formatter.string(from: Date())
        
        // updating the date to currentdate for date picker  for initial launch
        arrData[1] = ["type":"date", "value":currentDate, "height":70.0]
        
        if userCurrentLocCord != nil
        {
            // location
            arrData[2] = ["type":"currentLocation", "value":self.userCurrentLocCord!, "selected":false, "image":"location_off", "height":105.0]
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        callValidateVisit()
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
    
    @objc func btnSubmitClick(btn:UIButton)
    {
        print("Call Api to Save")
        callRegisterVisit()
    }
}

extension VisitZoneVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let d:[String:Any] = arrData[indexPath.row]
        if let height:Double = d["height"] as? Double{
            return CGFloat(height)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            
            if strType == "picker"{
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.isDatePicker = false
                cell.tfPickers.text = ""
                cell.strPickerTitle_Key = "zone_name"
                cell.arrPicker = self.arrPicker
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "dropDown")
                
                cell.tfPickers.placeholder = "Zona"
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let str:String = dict["string"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = d
                    if let str:String = d["zone_name"] as? String
                    {
                        dict["string"] = str
                    }
                    self.arrData[index] = dict
                    self.callValidateVisit()
                }
                return cell
            }
            else if strType == "date"{
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.isDatePicker = true
                cell.arrPicker = []
                cell.tfPickers.text = ""
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "cal")
                
                cell.tfPickers.placeholder = "Fecha"
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let str:String = dict["value"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = strTF
                    self.arrData[index] = dict
                    self.callValidateVisit()
                }
                return cell
            }
            else if strType == "currentLocation"{
                let cell:CellVisitZone_CurrentLocation = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_CurrentLocation", for: indexPath) as! CellVisitZone_CurrentLocation
                cell.selectionStyle = .none
                cell.lblDescription.text = ""
                
                cell.imgLocation.image = UIImage(named: "location_off")
                cell.lblGetLocation.textColor = UIColor(named: "AppOrange")
                
                if let check:Bool =  dict["selected"] as? Bool
                {
                    if check == true
                    {
                        cell.imgLocation.image = UIImage(named: "location_on")
                        cell.lblGetLocation.textColor = UIColor(named: "AppDarkBackground")
                    }
                }
                
                if let str:String = dict["string"] as? String
                {
                    cell.lblDescription.text = str
                }
                
                return cell
            }
            else if strType == "rewards"{
                let cell:CellVisitZone_Rewards = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Rewards", for: indexPath) as! CellVisitZone_Rewards
                cell.selectionStyle = .none
                cell.lblPoints.text = ""
                cell.lblDescription.text = ""
                
                if let str:String = dict["value"] as? String
                {
                    cell.lblPoints.text = str
                }
                if let str:String = dict["description"] as? String
                {
                    cell.lblDescription.text = str
                }
                return cell
            }
            else if strType == "submit"{
                let cell:CellVisitZone_Submit = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Submit", for: indexPath) as! CellVisitZone_Submit
                cell.selectionStyle = .none
                cell.btnSubmit.layer.cornerRadius = 10.0
                cell.btnSubmit.layer.masksToBounds = true
                cell.btnSubmit.addTarget(self, action: #selector(self.btnSubmitClick(btn:)), for: .touchUpInside)
                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]
        
        if let strType:String = dict["type"] as? String{
            if strType == "currentLocation"{
                
                if let check:Bool =  dict["selected"] as? Bool
                {
                    if check == false
                    {
                        // then only able to click it and request location
                        checkLocationEligibility()
                    }
                    else
                    {
                        // already have Location
                        if let coord:CLLocationCoordinate2D = dict["value"] as? CLLocationCoordinate2D
                        {
                            print(coord)
                        }
                    }
                }
            }
        }
    }
}

extension VisitZoneVC: CLLocationManagerDelegate
{
    func checkLocationEligibility()
    {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
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
        
        // Here Update ArrData & Reload Table
        
        var dict:[String:Any] = arrData[2] // location
        dict["value"] = self.userCurrentLocCord!
        arrData[2] = dict
                
        DispatchQueue.main.async {
            self.callValidateVisit()
        }
    }
}

extension VisitZoneVC
{
    func callValidateVisit()
    {
        var zone_id, visit_date, visit_latitude, visit_longitude :String!
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        for ind in 0..<arrData.count
        {
            var dict:[String:Any] = arrData[ind]
            if ind == 0
            {
                zone_id = ""
                if let dd:[String:Any] = dict["value"] as? [String:Any]
                {
                    if let str:String = dd["zone_id"] as? String
                    {
                        zone_id = str
                    }
                }
            }
            else if ind == 1
            {
                visit_date = ""
                if let str:String = dict["value"] as? String
                {
                    visit_date = str
                }
            }
            else if ind == 2
            {
                visit_latitude = "0"
                visit_longitude = "0"
                
                if userCurrentLocCord != nil
                {
                    visit_latitude = "\(userCurrentLocCord.latitude)"
                    visit_longitude = "\(userCurrentLocCord.longitude)"
                }
            }
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id!, "visit_date":visit_date!, "visit_latitude":visit_latitude!, "visit_longitude":visit_longitude!]
       // print(param)
        WebService.requestService(url: ServiceName.POST_ValidateVisit, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
    //        print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                self.navigationController?.popViewController(animated: true)
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
                                
                                if let a:[[String:Any]] = d["available_zones"] as? [[String:Any]]
                                {
                                    // For Picker
                                    self.arrPicker = a
                                    
                                    if let check:Int = d["current_zone_index"] as? Int
                                    {
                                        self.current_zone_index = check
                                    }
                                    
                                    if self.current_zone_index != nil
                                    {
                                            if self.current_zone_index >= 0 // if it is < 0 -1 then do not pick first value for zone picker
                                            {
                                                if a.count > 0
                                                {
                                                    let dPicker:[String:Any] = a[self.current_zone_index]
                                                    var dictP:[String:Any] = self.arrData[0]
                                                    
                                                    if let dp:[String:Any] = dictP["value"] as? [String:Any]
                                                    {
                                                        if dp.count == 0
                                                        {
                                                            dictP["value"] = dPicker
                                                            
                                                            if let str:String = dPicker["zone_name"] as? String
                                                            {
                                                                dictP["string"] = str
                                                            }
                                                            
                                                            self.arrData[0] = dictP
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                                
                                if let dl:[String:Any] = d["location"] as? [String:Any]
                                {
                                    // location description
                                    var dictP:[String:Any] = self.arrData[2]
                                   
                                    if let str:String = dl["description"] as? String
                                    {
                                        dictP["string"] = str
                                    }
                                    if let check:Bool =  dl["is_valid"] as? Bool
                                    {
                                        dictP["selected"] = check
                                    }
                                    self.arrData[2] = dictP
                                }
                                
                                if let dR:[String:Any] = d["rewards"] as? [String:Any]
                                {
                                    // location description
                                    var dictP:[String:Any] = self.arrData[3]
                                    
                                    if let str:String = dR["description"] as? String
                                    {
                                        dictP["description"] = str
                                    }
                                    if let point:String = dR["reward_str"] as? String
                                    {
                                        dictP["value"] = point
                                    }
                                    self.arrData[3] = dictP
                                }
                                
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callRegisterVisit()
    {
        var zone_id, visit_date, visit_latitude, visit_longitude :String!
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        for ind in 0..<arrData.count
        {
            var dict:[String:Any] = arrData[ind]
            if ind == 0
            {
                if let dd:[String:Any] = dict["value"] as? [String:Any]
                {
                    if let str:String = dd["zone_id"] as? String
                    {
                        zone_id = str
                    }
                }
            }
            else if ind == 1
            {
                if let str:String = dict["value"] as? String
                {
                    visit_date = str
                }
            }
            else if ind == 2
            {
                visit_latitude = "0"
                visit_longitude = "0"

                if userCurrentLocCord != nil
                {
                    visit_latitude = "\(userCurrentLocCord.latitude)"
                    visit_longitude = "\(userCurrentLocCord.longitude)"
                }
            }
        }
        
        if zone_id == nil
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor seleccione zona", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        if visit_date == nil
        {
            self.showAlertWithTitle(title: "Alerta", message: "Seleccione la fecha", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            return
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id!, "visit_date":visit_date!, "visit_latitude":visit_latitude!, "visit_longitude":visit_longitude!]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_RegisterVisit, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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

                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                var strTitle = ""
                                var strDesc = ""
                                var strRewards = ""
                                
                                if let str:String = d["title"] as? String
                                {
                                    strTitle = str
                                }
                                if let str:String = d["description"] as? String
                                {
                                    strDesc = str
                                }
                                if let str:String = d["reward_str"] as? String
                                {
                                    strRewards = str
                                }
                                
                                self.delegate.showPopUp(title: strTitle, desc: strDesc, points: strRewards)
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}
