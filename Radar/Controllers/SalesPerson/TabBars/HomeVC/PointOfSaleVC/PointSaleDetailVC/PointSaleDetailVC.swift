//
//  PointSaleDetailVC.swift
//  Radar
//
//  Created by Shalini Sharma on 3/8/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import CoreLocation

class PointSaleDetailVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var locationManager = CLLocationManager()

    var userCurrentLocCord:CLLocationCoordinate2D!
    var isLocationPresent = false
    var selectedImage:UIImage!
    
    var delegate:updateRootVCWithRewardsPopUpDelegate!
    
    var current_zone_index:Int!
    var short_formatted_address = ""
    var address_message : String = ""
    
    var zone_id = ""
    var pos_type = ""
    var pos_name = ""
    var media_id = ""
    var place_id = ""
    var in_location = ""
    var street_name = ""
    var street_number = ""
    var neighborhood = ""
    var municipality = ""
    var state = ""
    var zip_code = ""
    var comments = ""
    
    var arrData:[[String:Any]] = []
    
    var arrPicker_Zone:[[String:Any]] = []
    var arrPicker_TypePos:[[String:Any]] = []
    var arrPicker_State:[String] = []
    var arrPicker_Addresses:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        tblView.delegate = self
        tblView.dataSource = self
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()

        if isLocationPresent == false
        {
            // show Search Also
            // call 1 api on load
            
            arrData = [["type":"label", "value":"Información del Punto de Venta", "height":35.0],
                       ["type":"pickerZone", "value":[:], "string":"", "ph":"Zona", "height":70.0],
                       ["type":"pickerType", "value":[:], "string":"", "ph":"Tipo", "height":70.0],
                       ["type":"name", "value":"", "ph":"Nombre", "height":70.0],
                       ["type":"picture", "height":220.0],
                       ["type":"search", "height":450.0],
                       ["type":"addresses", "title":"Direcciones encontradas en la zona con base en tu ubicación", "ph":"No se encontraron direcciones. Revisa la zona seleccionada, verifica que estés presente en dicha zona y confirma que hayas dado permiso a la app para acceder a tu ubicación.", "height":"Calculate"],
                       ["type":"rewards", "value":"", "height":115.0],
                       ["type":"submit", "height":70.0]
            ]
            
            in_location = "0"
            
            callPosValidate(has_coordinates: "0")
        }
        else
        {
            // call 2 apis on load
            
            in_location = "1"
            
            arrData = [["type":"label", "value":"Información del Punto de Venta", "height":35.0],
                       ["type":"pickerZone", "value":[:], "string":"", "ph":"Zona", "height":70.0],
                       ["type":"pickerType", "value":[:], "string":"", "ph":"Tipo", "height":70.0],
                       ["type":"name", "value":"", "ph":"Nombre", "height":70.0],
                       ["type":"picture", "height":220.0],
                       ["type":"addresses", "title":"Direcciones encontradas en la zona con base en tu ubicación", "ph":"No se encontraron direcciones. Revisa la zona seleccionada, verifica que estés presente en dicha zona y confirma que hayas dado permiso a la app para acceder a tu ubicación.", "height":"Calculate"],
                       ["type":"notes", "valueTF":"", "valueTxtView":"", "height":190.0],
                       ["type":"rewards", "value":"", "height":115.0],
                       ["type":"submit", "height":70.0]
            ]
            
            callPosValidate(has_coordinates: "1")
            
           // call 2 apis
        }
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
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last
        
        self.userCurrentLocCord = location?.coordinate
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func btnBackClick(btn:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSubmitClick(btn:UIButton)
    {
        print("Call Api to Submit")
        callSubmitApi()
        
        /*
        if zone_id.isEmpty == true ||  pos_name.isEmpty == true || pos_type.isEmpty == true || media_id.isEmpty == true || place_id.isEmpty == true || state.isEmpty == true || zip_code.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerts", message: "Por favor ingrese los campos vacíos para buscar", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSubmitApi()
        }
        */
    }
    
    @objc func btnSelectPhotoClick(btn:UIButton)
    {
        print("Pick  Photo then Call Api to get media_id")
        pickAnImage()
    }
        
    @objc func btnSearchClick(btn:UIButton)
    {
        print("Call Api to Search")
        
        callSearchAddresses_No()
/*
        zone_id = "1505400340879"
        street_name = "Puerta de Hierro"
        street_number = "21"
        neighborhood = "Puerta de Hierro"
        municipality = "Metepec"
        state = "Estado de México"
        zip_code = "52140"

        if zone_id.isEmpty == true ||  street_name.isEmpty == true || street_number.isEmpty == true || neighborhood.isEmpty == true || municipality.isEmpty == true || state.isEmpty == true || zip_code.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerts", message: "Por favor ingrese los campos vacíos para buscar", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSearchAddresses_No()
        }
 */
    }
}

extension PointSaleDetailVC: UITableViewDataSource, UITableViewDelegate
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
        else if let _:String = d["height"] as? String{
            
            if isLocationPresent == false
            {
                // NO Case
                // radio button of addresses
                // with addres coll view
                if arrPicker_Addresses.count > 0
                {
                    return CGFloat(50 + (arrPicker_Addresses.count * 70))
                }
                else
                {
                    return 120 // title + No record found label
                }
            }
            else{
                // YES case
                return 160 // just one address as a string
            }
//            return 160 // Found Address
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
            else if strType == "pickerZone"{
                
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.isDatePicker = false
                cell.strPickerTitle_Key = "zone_name"
                cell.tfPickers.text = ""
                cell.arrPicker = self.arrPicker_Zone
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "dropDown")
                
                cell.tfPickers.placeholder = ""
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let strPh:String = dict["ph"] as? String
                {
                    cell.tfPickers.placeholder = strPh
                }
                
                if let str:String = dict["string"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = d
                    if let str:String = d["zone_id"] as? String
                    {
                        self.zone_id = str
                        
                        if self.isLocationPresent == true
                        {
                            // has_coordinates == "1"
                            self.callSearchAddresses_Yes()
                        }
                    }
                    if let str:String = d["zone_name"] as? String
                    {
                        dict["string"] = str
                    }
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else if strType == "pickerType"{
                
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.isDatePicker = false
                cell.strPickerTitle_Key = "pos_type_str"
                cell.tfPickers.text = ""
                cell.arrPicker = arrPicker_TypePos
                cell.tfPickers.delegate = cell
                cell.addRightView(imageName: "dropDown")
                
                cell.tfPickers.placeholder = ""
                cell.tfPickers.placeholderColor = .lightGray
                cell.tfPickers.borderActiveColor = k_baseColor
                cell.tfPickers.borderInactiveColor = .lightGray
                cell.tfPickers.placeholderFontScale = 1.0
                
                if let strPh:String = dict["ph"] as? String
                {
                    cell.tfPickers.placeholder = strPh
                }
                
                if let str:String = dict["string"] as? String
                {
                    cell.tfPickers.text = str
                }
                
                cell.completion = { (d:[String:Any], strTF:String, index:Int) in
                    dict["value"] = d
                    if let str:String = d["pos_type_str"] as? String
                    {
                        dict["string"] = str
                    }
                    if let str:Int = d["pos_type"] as? Int
                    {
                        self.pos_type = "\(str)"
                    }
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else if strType == "name"{
                let cell:CellVisitZone_TF = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_TF", for: indexPath) as! CellVisitZone_TF
                cell.selectionStyle = .none
                cell.index = indexPath.row
                cell.isDatePicker = false
                cell.arrPicker = []
                cell.tfPickers.text = ""
                cell.tfPickers.delegate = cell
                cell.tfPickers.placeholder = ""
                
                if let str:String = dict["ph"] as? String
                {
                    cell.tfPickers.placeholder = str
                }
                
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
                    self.pos_name = strTF
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }
                return cell
            }
            else if strType == "picture"{
                let cell:CellPointSale_Optional = tblView.dequeueReusableCell(withIdentifier: "CellPointSale_Optional", for: indexPath) as! CellPointSale_Optional
                cell.selectionStyle = .none
                cell.imgView.image = nil
                
                if selectedImage != nil && media_id != ""
                {
                    cell.imgView.image = selectedImage
                }
                
                cell.btnBox.layer.cornerRadius = 5.0
                cell.btnBox.layer.borderColor = UIColor(named: "AppGray")?.cgColor
                cell.btnBox.layer.borderWidth = 0.8
                cell.btnBox.layer.masksToBounds = true
                
                cell.btnSubmit.layer.cornerRadius = 8.0
                cell.btnSubmit.layer.masksToBounds = true
               
                cell.btnSubmit.addTarget(self, action: #selector(self.btnSelectPhotoClick(btn:)), for: .touchUpInside)
              //  cell.btnSubmit.addTarget(self, action: #selector(self.btnSubmitPhotoClick(btn:)), for: .touchUpInside)
                
                return cell
            }
            else if strType == "search"{
                let cell:CellPintSale_Search = tblView.dequeueReusableCell(withIdentifier: "CellPintSale_Search", for: indexPath) as! CellPintSale_Search
                cell.selectionStyle = .none
                
                cell.tfName.text = ""
                cell.tfNumber.text = ""
                cell.tfZipcode.text = ""
                cell.tfNeighborhood.text = ""
                cell.tfMunicipality.text = ""
                cell.tfState.text = ""
                
                cell.tfName.tag = 100
                cell.tfNumber.tag = 101
                cell.tfZipcode.tag = 102
                cell.tfNeighborhood.tag = 103
                cell.tfMunicipality.tag = 104
                cell.tfState.tag = 105
                
                cell.tfName.delegate = cell
                cell.tfName.placeholder = "Calle"
                cell.tfName.placeholderColor = .lightGray
                cell.tfName.borderActiveColor = k_baseColor
                cell.tfName.borderInactiveColor = .lightGray
                cell.tfName.placeholderFontScale = 1.0
                
                cell.tfNumber.delegate = cell
                cell.tfNumber.placeholder = "Num. Ext"
                cell.tfNumber.placeholderColor = .lightGray
                cell.tfNumber.borderActiveColor = k_baseColor
                cell.tfNumber.borderInactiveColor = .lightGray
                cell.tfNumber.placeholderFontScale = 1.0
                
                cell.tfZipcode.delegate = cell
                cell.tfZipcode.placeholder = "Código Postal"
                cell.tfZipcode.placeholderColor = .lightGray
                cell.tfZipcode.borderActiveColor = k_baseColor
                cell.tfZipcode.borderInactiveColor = .lightGray
                cell.tfZipcode.placeholderFontScale = 1.0
                
                cell.tfNeighborhood.delegate = cell
                cell.tfNeighborhood.placeholder = "Colonia / Asentamiento"
                cell.tfNeighborhood.placeholderColor = .lightGray
                cell.tfNeighborhood.borderActiveColor = k_baseColor
                cell.tfNeighborhood.borderInactiveColor = .lightGray
                cell.tfNeighborhood.placeholderFontScale = 1.0
                
                cell.tfMunicipality.delegate = cell
                cell.tfMunicipality.placeholder = "Municipio"
                cell.tfMunicipality.placeholderColor = .lightGray
                cell.tfMunicipality.borderActiveColor = k_baseColor
                cell.tfMunicipality.borderInactiveColor = .lightGray
                cell.tfMunicipality.placeholderFontScale = 1.0
                
                cell.tfState.delegate = cell
                cell.tfState.placeholder = "Estado"
                cell.tfState.placeholderColor = .lightGray
                cell.tfState.borderActiveColor = k_baseColor
                cell.tfState.borderInactiveColor = .lightGray
                cell.tfState.placeholderFontScale = 1.0
                cell.arrPicker = self.arrPicker_State
                cell.addRightView(imageName: "dropDown")
                
                cell.btnSearch.layer.cornerRadius = 8.0
                cell.btnSearch.layer.masksToBounds = true
                cell.btnSearch.addTarget(self, action: #selector(self.btnSearchClick(btn:)), for: .touchUpInside)
                
                cell.completion = {(strTF:String, indexTag:Int) in
                    if indexTag == 100
                    {
                        self.street_name = strTF
                    }
                    else if indexTag == 101
                    {
                        self.street_number = strTF
                    }
                    else if indexTag == 102
                    {
                        self.zip_code = strTF
                    }
                    else if indexTag == 103
                    {
                        self.neighborhood = strTF
                    }
                    else if indexTag == 104
                    {
                        self.municipality = strTF
                    }
                    else if indexTag == 105
                    {
                        self.state = strTF
                    }
                    self.tblView.reloadData()
                }
                
                cell.tfName.text = self.street_name
                cell.tfNumber.text = self.street_number
                cell.tfZipcode.text = self.zip_code
                cell.tfNeighborhood.text = self.neighborhood
                cell.tfMunicipality.text = self.municipality
                cell.tfState.text = self.state
                
                return cell
            }
            else if strType == "addresses"{
                let cell:CellPintSale_Addresses = tblView.dequeueReusableCell(withIdentifier: "CellPintSale_Addresses", for: indexPath) as! CellPintSale_Addresses
                cell.selectionStyle = .none
                cell.lblTitle.text = ""
                cell.lblNoRecord.text = ""
                cell.lblNoRecord.isHidden = true
                cell.collView.isHidden = true
                cell.arrData = self.arrPicker_Addresses
                
                cell.lblTitle.text = "Direcciones encontradas en la zona con base en tu ubicación"
                cell.lblNoRecord.text = "No se encontraron direcciones. Revisa la zona seleccionada, verifica que estés presente en dicha zona y confirma que hayas dado permiso a la app para acceder a tu ubicación."
                
                if isLocationPresent == false
                {
                    // has_coordinates == "0"
                    if self.arrPicker_Addresses.count == 0
                    {
                        cell.lblNoRecord.isHidden = false
                    }
                    else
                    {
                        cell.collView.isHidden = false
                    }
                    cell.closure = {(fullArray:[[String:Any]], selectedPlaceID:String) in
                        
                        self.arrPicker_Addresses = fullArray
                        self.place_id = selectedPlaceID
                    }
                }
                else
                {
                    //  has_coordinates == "1"
                    
                    cell.collView.isHidden = true
                    cell.lblNoRecord.isHidden = false
                    
                    if current_zone_index != nil
                    {
                        if current_zone_index >= 0
                        {
                            if short_formatted_address != ""
                            {
                                cell.lblNoRecord.text = short_formatted_address
                            }
                        }
                        else
                        {
                            if address_message != ""
                            {
                                cell.lblNoRecord.text = address_message
                            }
                        }
                    }
                }
                
                return cell
            }
            else if strType == "rewards"{
                let cell:CellVisitZone_Rewards = tblView.dequeueReusableCell(withIdentifier: "CellVisitZone_Rewards", for: indexPath) as! CellVisitZone_Rewards
                cell.selectionStyle = .none
                cell.lblPoints.text = ""
                cell.lblDescription.text = ""
              //  print(dict)
                
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
            else if strType == "notes"{
//                ["type":"notes", "valueTF":"", "valueTxtView":"", "height":115.0]
                let cell:CellPointSale_Notes = tblView.dequeueReusableCell(withIdentifier: "CellPointSale_Notes", for: indexPath) as! CellPointSale_Notes
                cell.selectionStyle = .none
                cell.backgroundColor = .clear                
                
                cell.index = indexPath.row
                cell.tf.text = ""
                cell.tf.delegate = cell
                cell.tf.placeholder = "Número Exterior (Si Aplica):"
                cell.tf.placeholderColor = .lightGray
                cell.tf.borderActiveColor = k_baseColor
                cell.tf.borderInactiveColor = .lightGray
                cell.tf.placeholderFontScale = 1.0
                
                cell.txtView.text = ""
                cell.txtView.delegate = cell
                cell.txtView.layer.cornerRadius = 6.0
                cell.txtView.layer.borderColor = UIColor.lightGray.cgColor
                cell.txtView.layer.borderWidth = 0.8
                cell.txtView.layer.masksToBounds = true
                
                if let str:String = dict["valueTF"] as? String
                {
                    cell.tf.text = str
                }
                if let str:String = dict["valueTxtView"] as? String
                {
                    cell.txtView.text = str
                }
                
                cell.closure = {(txt:String, isTxtView:Bool, index:Int) in
                    if isTxtView == true
                    {
                        self.comments = txt
                        dict["valueTxtView"] = txt
                    }
                    else
                    {
                        self.street_number = txt
                        dict["valueTF"] = txt
                    }
                    
                    self.arrData[index] = dict
                    self.tblView.reloadData()
                }

                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict:[String:Any] = arrData[indexPath.row]
    }
}

extension PointSaleDetailVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func pickAnImage()
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "Radar", message: "Elija una opción", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Tomar la foto", style: .default) { action -> Void in
            if(  UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.allowsEditing = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            else
            {
                let actionController: UIAlertController = UIAlertController(title: "La cámara no está disponible.",message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void     in
                    //Just dismiss the action sheet
                }
                
                actionController.addAction(cancelAction)
                self.present(actionController, animated: true, completion: nil)
                
            }
        }
        
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Elegir de la galería", style: .default) { action -> Void in
            
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.allowsEditing = true
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImage = editedImage
            DispatchQueue.main.async {
                // CALL API TO UPLOAD TEMP IMAGE
                self.callUploadProfileImgApi(img: editedImage)
            }
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImage = originalImage
            DispatchQueue.main.async {
                // CALL API TO UPLOAD TEMP IMAGE
                self.callUploadProfileImgApi(img: originalImage)
            }
        }
        else{
            print("Something went wrong!! NO IMAGE PICKED - - ")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func callUploadProfileImgApi(img:UIImage)
    {
        self.showSpinnerWith(title: "Cargando...")
        
        WebService.uploadImage(url: ServiceName.POST_UploadImagePOS, method: .post, parameter: [:], header: [:], image: img, viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
           // print(jsonString)
            
            if error != nil
            {
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
                        
                        if let dict:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let str:String = dict["media_id"] as? String
                            {
                                self.media_id = str
                            }
                        }
                        DispatchQueue.main.async {
                            self.tblView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
}

