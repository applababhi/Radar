//
//  VisitZoneVC.swift
//  Radar
//
//  Created by Shalini Sharma on 2/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import CoreLocation

class NewSaleVC: UIViewController {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var userCurrentLocCord:CLLocationCoordinate2D!
    
    var current_zone_index:Int!
    
    var arrData:[[String:Any]] = [["type":"label", "value":"Información del Punto de Venta", "height":35.0],
                                  ["type":"picker", "value":[:], "string":"", "height":70.0],
                                  ["type":"picker", "value":[:], "string":"", "height":70.0],
                                  ["type":"picker", "value":[:], "string":"", "height":70.0],
                                  ["type":"date", "value":"", "height":70.0],
                                  ["type":"scanAdd", "valuePicker":[:], "valueScan":"", "height":224.0],
                                  ["type":"currentLocation", "value":"", "selected":false, "image":"location_off", "height":105.0],
                                  ["type":"rewards", "value":"+5", "height":115.0],
                                  ["type":"submit", "height":70.0]
    ]
    
    var check_FirstTimeApiCall = true
    
    var arrPicker_Zone:[[String:Any]] = []
    var arrPicker_Type:[[String:Any]] = []
    var arrPicker_POS:[[String:Any]] = []
    var arrPicker_ScanProducts:[[String:Any]] = []
    
    var zone_id = ""
    var pos_id = ""
    var sale_type = ""
    var sale_date = ""
    var products:[[String:Any]] = []
    var descriptionLocation = ""
    var isValidLocation = false
    var descriptionRewards = ""
    var pointsRewards = 0
    
    var delegate:updateRootVCWithRewardsPopUpDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate:String = formatter.string(from: Date())
        self.sale_date = currentDate
        // updating the date to currentdate for date picker  for initial launch
        arrData[4] = ["type":"date", "value":currentDate, "height":70.0]
        
        callValidateNewSale(zone_id: "0")
        
        tblView.delegate = self
        tblView.dataSource = self
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
        print("Call Api to Submit")
        if zone_id.isEmpty == true ||  sale_type.isEmpty == true || sale_date.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese los campos vacíos para buscar", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else if products.count == 0
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor agrega al menos un ICCID válido", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSubmitApi()
        }
    }
    
    @objc func btnDeleteUDIDClick(btn:UIButton)
    {
        let indexToDeleteFromProducts:Int = btn.tag - 6
        
        print("Delete UDID Row from Products Aray Index - ", indexToDeleteFromProducts)
        self.products.remove(at: indexToDeleteFromProducts)
        print("left Products Array - ", self.products)
        
        print("Delete UDID Row from Main Aray Index - ", btn.tag)
        arrData.remove(at: btn.tag)
        self.tblView.reloadData()
    }
    
    @objc func btnAddUDIDClick(btn:UIButton)
    {
        print("Call API - - Add UDID to List")
        
        // ["type":"scanAdd", "valuePicker":[:], "valueScan":"", "height":224.0]
        let dict:[String:Any] = arrData[btn.tag]
        if let d:[String:Any] = dict["valuePicker"] as? [String:Any]
        {
            if let str:String = dict["valueScan"] as? String
            {
                if d.count != 0 && str != ""
                {
                    if let strID:String = d["participant_product_id"] as? String
                    {
                        self.callValidateSIMcard(ICCID: str, indexToResetValueInMainArray: btn.tag, dictToSaveInProducts: ["iccid":str, "participant_product_id":strID])
                    }
                }
                else
                {
                    print("Show Alert")
                    self.showAlertWithTitle(title: "Alerta", message: "Por favor ingresa un ICCID.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                }
            }
        }
        else{
            print("Show Alert")
            self.showAlertWithTitle(title: "Alerta", message: "Indica el estado del SIM para continuar", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        
    }
    
    @objc func btnScanBarcodeClick(btn:UIButton)
    {
        print("Scan bar Code")
        let vc:BarCodeScanVC = BarCodeScanVC()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension NewSaleVC: UITableViewDataSource, UITableViewDelegate
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
            
            if strType == "label"{
                
                let cell:CellPoint_Label = tblView.dequeueReusableCell(withIdentifier: "CellPoint_Label", for: indexPath) as! CellPoint_Label
                cell.selectionStyle = .none
                
                return cell
            }
            else if strType == "picker"{
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.tfPickers.placeholder = ""
                cell.index = indexPath.row
                cell.isDatePicker = false
                cell.tfPickers.text = ""
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "dropDown")
                cell.strPickerTitle_Key = ""
                
                cell.tfPickers.isUserInteractionEnabled = true
                cell.tfPickers.alpha = 1.0
                
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if indexPath.row == 1
                {
                    cell.strPickerTitle_Key = "zone_name"
                    cell.arrPicker = self.arrPicker_Zone
                    cell.tfPickers.placeholder = "Zona"
                }
                else if indexPath.row == 2
                {
                    cell.strPickerTitle_Key = "sale_type_str"
                    cell.arrPicker = self.arrPicker_Type
                    cell.tfPickers.placeholder = "Tipo de Venta"
                }
                else if indexPath.row == 3{
                    
                    if self.sale_type != "1"
                    {
                        cell.tfPickers.isUserInteractionEnabled = false
                        cell.tfPickers.alpha = 0.5
                        
                        self.pos_id = ""
                    }
                    
                    cell.strPickerTitle_Key = "pos_name"
                    cell.arrPicker = self.arrPicker_POS
                    cell.tfPickers.placeholder = "Selecciona un Punto de Venta"
                }
                
                if let str:String = dict["string"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = d
                    
                    if index == 1
                    {
                        // Zone
                        
                        // on every zone change call Api
                        
                        if let str:String = d["zone_name"] as? String
                        {
                            dict["string"] = str
                        }
                        if let str:String = d["zone_id"] as? String
                        {
                            self.zone_id = str
                        }
                        self.arrData[index] = dict
                        self.callValidateNewSale(zone_id: self.zone_id)
                    }
                    else if index == 2
                    {
                        // Type
                        
                        // If Type Id is 1, disable POS Section
                        
                        if let str:String = d["sale_type_str"] as? String
                        {
                            dict["string"] = str
                        }
                        if let type:Int = d["sale_type"] as? Int
                        {
                            self.sale_type = "\(type)"
                            
                            if type != 1
                            {
                                self.pos_id = ""
                            }
                        }
                        self.arrData[index] = dict
                        self.tblView.reloadData()
                    }
                    else if index == 3
                    {
                        // POS
                        
                        if let str:String = d["pos_name"] as? String
                        {
                            dict["string"] = str
                        }
                        if let id:String = d["pos_id"] as? String
                        {
                            self.pos_id = id
                        }
                        self.arrData[index] = dict
                        self.tblView.reloadData()
                    }
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
                    self.sale_date = strTF
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else if strType == "scanAdd"{
                let cell:CellNewSaleScan = tblView.dequeueReusableCell(withIdentifier: "CellNewSaleScan", for: indexPath) as! CellNewSaleScan
                cell.selectionStyle = .none
                cell.tfID.text = ""
                cell.tfPicker.text = ""
                cell.tfID.delegate = cell
                cell.tfPicker.delegate = cell
                cell.index = indexPath.row
                cell.lblIDs.isHidden = true
                cell.tfPicker.isUserInteractionEnabled = true
                
                // ["type":"udid", "value":str, "height":35.0]
                let udidDictIsAvailable:[String:Any] = self.arrData[indexPath.row + 1]
                if let checkTypeExist:String = udidDictIsAvailable["type"] as? String
                {
                    if checkTypeExist == "udid"{
                        cell.lblIDs.isHidden = false
                    }
                }
                
                cell.arrPicker = self.arrPicker_ScanProducts
                if arrPicker_ScanProducts.count == 0
                {
                    cell.tfPicker.isUserInteractionEnabled = false
                }
                
                cell.tfID.placeholder = "ICCID de SIM"
                cell.tfID.placeholderColor = .lightGray
                cell.tfID.borderActiveColor = k_baseColor
                cell.tfID.borderInactiveColor = .lightGray
                cell.tfID.placeholderFontScale = 1.0
                
                cell.tfPicker.placeholder = "Estado del SIM"
                cell.tfPicker.placeholderColor = .lightGray
                cell.tfPicker.borderActiveColor = k_baseColor
                cell.tfPicker.borderInactiveColor = .lightGray
                cell.tfPicker.placeholderFontScale = 1.0
                cell.addRightView(imageName: "dropDown")
                
                cell.btnScan.tag = indexPath.row
                cell.btnAdd.tag = indexPath.row
                
                cell.btnScan.addTarget(self, action: #selector(self.btnScanBarcodeClick(btn:)), for: .touchUpInside)
                cell.btnAdd.addTarget(self, action: #selector(self.btnAddUDIDClick(btn:)), for: .touchUpInside)
                
                // ["type":"scanAdd", "valuePicker":[:], "valueScan":"", "height":224.0]
                
                if let str:String = dict["valueScan"] as? String
                {
                    if str == ""
                    {
                        // it's for first time, when page load so show first value from array
                        if self.arrPicker_ScanProducts.count > 0
                        {
                            let dictFirst:[String:Any] = self.arrPicker_ScanProducts.first!
                            if let strValue:String = dictFirst["product_name"] as? String{
                                cell.tfID.text = strValue
                              //  dict["valueScan"] = strValue
                                dict["valuePicker"] = dictFirst
                                self.arrData[indexPath.row] = dict
                            }
                        }
                    }
                }
                
                if let str:String = dict["valueScan"] as? String
                {
                    cell.tfID.text = str
                }
                if let d:[String:Any] = dict["valuePicker"] as? [String:Any]
                {
                    if let str:String = d["product_name"] as? String
                    {
                        cell.tfPicker.text = str
                    }
                }
                
                cell.completion = {(dictM:[String:Any], strTF:String, index:Int) in
                    if dictM.count == 0
                    {
                        // it's Plain scan TF
                        var di:[String:Any] = self.arrData[index] // ScanAdd Type
                        di["valueScan"] = strTF
                        self.arrData[index] = di
                        self.tblView.reloadData()
                    }
                    else{
                        // picker
                        var di:[String:Any] = self.arrData[index] // ScanAdd Type
                        di["valuePicker"] = dictM
                        self.arrData[index] = di
                        self.tblView.reloadData()
                    }
                }
                
                return cell
            }
            else if strType == "udid" // if Available
            {
                let cell:CellNewSaleUDIDs = tblView.dequeueReusableCell(withIdentifier: "CellNewSaleUDIDs", for: indexPath) as! CellNewSaleUDIDs
                cell.selectionStyle = .none
                
                cell.tfID.text = ""
                cell.tfID.isUserInteractionEnabled = false
                
                if let str:String = dict["value"] as? String
                {
                    cell.tfID.text = str
                }
                cell.btnDelete.tag = indexPath.row
                
                cell.btnDelete.addTarget(self, action: #selector(self.btnDeleteUDIDClick(btn:)), for: .touchUpInside)
                return cell
            }
            else if strType == "currentLocation"{
                let cell:CellVisitZone_CurrentLocation = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_CurrentLocation", for: indexPath) as! CellVisitZone_CurrentLocation
                cell.selectionStyle = .none
                
                cell.imgLocation.image = UIImage(named: "location_off")
                cell.lblGetLocation.textColor = UIColor(named: "AppOrange")
                cell.lblDescription.text = descriptionLocation
                
                if isValidLocation == true
                {
                    cell.imgLocation.image = UIImage(named: "location_on")
                    cell.lblGetLocation.textColor = UIColor(named: "AppDarkBackground")
                }
                
                if let coord:CLLocationCoordinate2D = dict["value"] as? CLLocationCoordinate2D
                {
                    print("Fetched Location - ", coord)
                    cell.imgLocation.image = UIImage(named: "location_on")
                    cell.lblGetLocation.textColor = UIColor(named: "AppDarkBackground")
                }
                
                return cell
            }
            else if strType == "rewards"{
                let cell:CellVisitZone_Rewards = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Rewards", for: indexPath) as! CellVisitZone_Rewards
                cell.selectionStyle = .none
                cell.lblPoints.text = "\(pointsRewards * (products.count))"
                cell.lblDescription.text = descriptionRewards
                
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
                if let coord:CLLocationCoordinate2D = dict["value"] as? CLLocationCoordinate2D
                {
                    print(coord)
                }
                else{
                    // Call Current Location Method
                    checkLocationEligibility()
                }
            }
        }
    }
}

extension NewSaleVC: CLLocationManagerDelegate
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
        
        let indexOfLocation = arrData.count - 3
        let indexOfReward = arrData.count - 2
        
        var dict:[String:Any] = arrData[indexOfLocation] // location
        dict["value"] = self.userCurrentLocCord!
        arrData[indexOfLocation] = dict
        
        var dictRewards:[String:Any] = arrData[indexOfReward] // Also Update Rewards - TEMPORARY
        dictRewards["value"] = "+20"
        arrData[indexOfReward] = dictRewards
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

extension NewSaleVC: BarCodeScanDelegate
{
    func scannedBarcode(strCode: String) {
        print("Fetched Code Updated to Array & Reload Table - ", strCode)
        // ["type":"scanAdd", "valuePicker":[:], "valueScan":"", "height":224.0]
        var dict:[String:Any] = arrData[5] // ScanAdd Type
        dict["valueScan"] = strCode // code to test  - 6532698541576352112
        self.arrData[5] = dict
        self.tblView.reloadData()
    }
}

extension NewSaleVC
{
    func callValidateNewSale(zone_id:String)
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        // "actions/sales/validate"
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id, "sale_latitude": userCurrentLocCord.latitude, "sale_longitude": userCurrentLocCord.longitude]
     //    print(param)
        WebService.requestService(url: ServiceName.POST_NewSale_Validate, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
       //      print(jsonString)
            
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
                            if let arr:[[String:Any]] = d["available_zones"] as? [[String:Any]]
                            {
                                self.arrPicker_Zone = arr
                                
                                if self.check_FirstTimeApiCall == true
                                {
                                    
                                    if let check:Int = d["current_zone_index"] as? Int
                                    {
                                        self.current_zone_index = check
                                    }
                                    
                                    if self.current_zone_index != nil
                                    {
                                        if self.current_zone_index >= 0 // if it is < 0 -1 then do not pick first value for zone picker
                                        {
                                            if arr.count > 0
                                            {
                                                var dMain:[String:Any] = self.arrData[1] // Zone
                                                
                                                let dp:[String:Any] = arr[self.current_zone_index]
                                                
                                                dMain["value"] = dp
                                                if let str:String = dp["zone_name"] as? String
                                                {
                                                    dMain["string"] = str
                                                }
                                                if let str:String = dp["zone_id"] as? String
                                                {
                                                    self.zone_id = str
                                                }
                                                self.arrData[1] = dMain
                                            }
                                        }
                                    }
                                }
                            }
                            if let arr:[[String:Any]] = d["sale_types"] as? [[String:Any]]
                            {
                                self.arrPicker_Type = arr
                                if arr.count > 0
                                {
                                    var dMain:[String:Any] = self.arrData[2] // Type
                                    
                                    let dp:[String:Any] = arr.first!
                                    
                                    dMain["value"] = dp
                                    if let str:String = dp["sale_type_str"] as? String
                                    {
                                        dMain["string"] = str
                                    }
                                    if let str:Int = dp["sale_type"] as? Int
                                    {
                                        self.sale_type = "\(str)"
                                    }
                                    self.arrData[2] = dMain
                                }
                            }
                            if let arr:[[String:Any]] = d["points_of_sale"] as? [[String:Any]]
                            {
                                self.arrPicker_POS = arr
                                if arr.count > 0
                                {
                                    var dMain:[String:Any] = self.arrData[3] // Zone
                                    
                                    let dp:[String:Any] = arr.first!
                                    
                                    dMain["value"] = dp
                                    if let str:String = dp["pos_name"] as? String
                                    {
                                        dMain["string"] = str
                                    }
                                    if let str:String = dp["pos_id"] as? String
                                    {
                                        self.pos_id = str
                                    }
                                    self.arrData[3] = dMain
                                }
                            }
                            if let arr:[[String:Any]] = d["participant_products"] as? [[String:Any]]
                            {
                                self.arrPicker_ScanProducts = arr
                            }
                            if let dLoc:[String:Any] = d["location"] as? [String:Any]
                            {
                                if let strDesc:String = dLoc["description"] as? String
                                {
                                    self.descriptionLocation = strDesc
                                }
                                if let check:Bool = dLoc["is_valid"] as? Bool
                                {
                                    self.isValidLocation = check
                                }
                            }
                            if let dRewd:[String:Any] = d["rewards"] as? [String:Any]
                            {
                               // print(dRewd)
                                if let strDesc:String = dRewd["description"] as? String
                                {
                                    self.descriptionRewards = strDesc
                                }
                                if let point:Int = dRewd["reward"] as? Int
                                {
                                    self.pointsRewards = point
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.check_FirstTimeApiCall = false
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
        
    func callValidateSIMcard(ICCID:String, indexToResetValueInMainArray:Int, dictToSaveInProducts:[String:Any]){
                
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["iccid":ICCID]
        // "actions/sales/iccid/validate"
        WebService.requestService(url: ServiceName.GET_ValidateSIM, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
         //       print(jsonString)
            
            if error != nil
            {
                // Error
                print("Error - ", error!)
                var dict:[String:Any] = self.arrData[indexToResetValueInMainArray]
                 // reset addscan tab on insert new row
                // dict["valuePicker"] = [:]
                 dict["valueScan"] = ""
                 self.arrData[indexToResetValueInMainArray] = dict
                
                self.showAlertWithTitle(title: "Radar", message: "\(error!.localizedDescription)", okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.reloadTable))
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
                            var dict:[String:Any] = self.arrData[indexToResetValueInMainArray]
                             // reset addscan tab on insert new row
                            // dict["valuePicker"] = [:]
                             dict["valueScan"] = ""
                             self.arrData[indexToResetValueInMainArray] = dict

                            self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: #selector(self.reloadTable))
                            return
                        }
                    }
                    else
                    {
                        // Pass
                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            DispatchQueue.main.async {
                                
                                var dict:[String:Any] = self.arrData[indexToResetValueInMainArray]
                                // reset addscan tab on insert new row
                               // dict["valuePicker"] = [:]
                                dict["valueScan"] = ""
                                self.arrData[indexToResetValueInMainArray] = dict
                                
                                self.products.append(dictToSaveInProducts)
                                
                                // reward Amount * products count
                                
                                // Insert always at index 6 for new UDID in Main Array
                                // ["type":"udid", "value":"", "height":35.0]
                                self.arrData.insert(["type":"udid", "value":ICCID, "height":35.0], at: indexToResetValueInMainArray + 1)
                                self.tblView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callSubmitApi()
    {
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        // "actions/sales/register"
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id, "pos_id":pos_id, "sale_type": sale_type, "sale_date":sale_date, "sale_latitude":userCurrentLocCord.latitude, "sale_longitude":userCurrentLocCord.longitude, "products":products]
    //    print(param)
        WebService.requestService(url: ServiceName.POST_NewSim_Register, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                                // call protocol for rewardsd popup
                               
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
                                
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func reloadTable()
    {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
