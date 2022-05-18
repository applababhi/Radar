//
//  ZonesSupervisroVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class ZonesSupervisroVC: UIViewController {
    
    @IBOutlet weak var tfPeriod: HoshiTextField!
    @IBOutlet weak var tblView: UITableView!
    
    var arrData:[[String:Any]] = []
    
    var arrPicker:[[String:Any]] = []
    var picker : UIPickerView!
    var dictPickerSelected:[String:Any] = [:]
    var strPickerId = ""
    var strName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfPeriod.isUserInteractionEnabled = false
        
        addRightPaddingTo(textField: tfPeriod, imageName: "dropDown")
        
        tfPeriod.placeholder = "Mostrar"
        tfPeriod.placeholderColor = .lightGray
        tfPeriod.borderActiveColor = k_baseColor
        tfPeriod.borderInactiveColor = .lightGray
        tfPeriod.placeholderFontScale = 1.0
        tfPeriod.delegate = self
        
        callCatalogue()
        self.tblView.dataSource = self
        self.tblView.delegate = self
    }
    
    @IBAction func btnBackClick(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdduserClick(btn:UIButton)
    {
        callGetZoneSummary()
    }
}


extension ZonesSupervisroVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if arrPicker.count != 0
        {
            // it's a picker
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfPeriod.text = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ZonesSupervisroVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfPeriod.inputView = self.picker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(self.donePickerClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //  let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelPickerClick))
        //  toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        tfPeriod.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfPeriod.resignFirstResponder()
    }
    
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfPeriod.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: CustomFont.regular, size: 19)
        pickerLabel.textColor = UIColor.black
        pickerLabel.textAlignment = .center
        pickerLabel.text = ""
        
        let dict:[String:Any] = arrPicker[row]
        
        if let strValue:String = dict["value"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
        if let strTitle:String = self.dictPickerSelected["value"] as? String{
            self.tfPeriod.text =  strTitle
        }
        
        if let strValue:Int = self.dictPickerSelected["id"] as? Int{
            self.strPickerId = "\(strValue)"
            self.callZoneHistory(id: "\(strValue)")
        }
    }
}


extension ZonesSupervisroVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dic:[String:Any] = arrData[indexPath.row]
        let cell:CellZoneSupervisor = tblView.dequeueReusableCell(withIdentifier: "CellZoneSupervisor", for: indexPath) as! CellZoneSupervisor
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblSubtitle.text = ""
        cell.btnCross.isHidden = true
        cell.imgCross.isHidden = true
        
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(self.btnDeleteClick(btn:)), for: .touchUpInside)
        
        if let str:String = dic["zone_name"] as? String
        {
            cell.lblTitle.text = str
        }
        
        if let check:Bool = dic["can_remove"] as? Bool
        {
            if check == true
            {
                cell.btnCross.isHidden = false
                cell.imgCross.isHidden = false
            }
        }
        
        if let str:String = dic["description"] as? String
        {
            cell.lblSubtitle.text = str
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func btnDeleteClick(btn:UIButton)
    {
        let dic:[String:Any] = arrData[btn.tag]
        if let strUUID:String = dic["uuid"] as? String
        {
            if let strzoneid:String = dic["zone_id"] as? String
            {
                let alertController = UIAlertController(title: "Radar", message: "¿Estás seguro de que deseas desasignar la zona de este usuario?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "sí", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.callDisableZone(zoneID: strzoneid, uuid: strUUID)
                }
                let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel- ")
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)

            }
        }
    }
}

extension ZonesSupervisroVC
{
    func callCatalogue(){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["catalogue_id":20]
        
        WebService.requestService(url: ServiceName.GET_ZoneCatalog, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
          //  print(jsonString)
            
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
                        if let du:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arrperiod:[[String:Any]] = du["values"] as? [[String:Any]]
                            {
                                self.arrPicker = arrperiod
                                
                                DispatchQueue.main.async {
                                    if arrperiod.count > 0
                                    {
                                        self.tfPeriod.isUserInteractionEnabled = true
                                        let dicth:[String:Any] = arrperiod.first!
                                        if let strTitle:String = dicth["value"] as? String{
                                            self.tfPeriod.text =  strTitle
                                        }
                                        if let strValue:Int = dicth["id"] as? Int{
                                            self.strPickerId = "\(strValue)"
                                            self.callZoneHistory(id: "\(strValue)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callZoneHistory(id:String){
        
        var uuid = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
        {
            uuid = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "status":id]
       // print(param)
        WebService.requestService(url: ServiceName.GET_ZoneHistory, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
     //       print(jsonString)
            
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
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let arr:[[String:Any]] = dJson["historial_zones"] as? [[String:Any]]
                            {
                                self.arrData = arr
                                DispatchQueue.main.async {
                                    self.tblView.reloadData()
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func callDisableZone(zoneID:String, uuid:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zoneID]
        WebService.requestService(url: ServiceName.GET_DisableUser, method: .post, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
             print(jsonString)
            
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
                        if let _:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            if let msg:String = json["message"] as? String
                            {
                                print(msg)
                                DispatchQueue.main.async {
                                    let alertController = UIAlertController(title: "Radar", message: "La zona se desasignó correctamente del usuario", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        self.callZoneHistory(id: self.strPickerId)
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
        
    func callGetZoneSummary(){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id]
        
        WebService.requestService(url: ServiceName.GET_ZoneSummaryAssign, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arrperiod:[[String:Any]] = json["response_object"] as? [[String:Any]]
                        {
                            DispatchQueue.main.async {
                                let vc:AssignVC = AppStoryBoards.HomeSupervisor.instance.instantiateViewController(identifier: "AssignVC_ID") as! AssignVC
                                vc.arrPicker = arrperiod
                                vc.strUser_Name = self.strName
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
