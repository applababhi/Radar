//
//  AssignVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class AssignVC: UIViewController {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var tfZone: HoshiTextField!
    @IBOutlet weak var tfName: HoshiTextField!
    @IBOutlet weak var tblView:UITableView!
    
    @IBOutlet weak var c_ArcView_Ht:NSLayoutConstraint!
    @IBOutlet weak var c_LblTitle_Top:NSLayoutConstraint!
    
    var arrData:[[String:Any]] = []
            var arrPicker:[[String:Any]] = []
            var picker : UIPickerView!
            var dictPickerSelected:[String:Any] = [:]
    
    var zone_id = ""
    var strUser_Name = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = "Asignar Usuario a Zona"
        
        tfName.placeholder = "Nombre de Usuario"
        tfName.placeholderColor = .lightGray
        tfName.borderActiveColor = k_baseColor
        tfName.borderInactiveColor = .lightGray
        tfName.placeholderFontScale = 1.0
        tfName.delegate = self

        tfZone.placeholder = "Selecciona una Zona"
        tfZone.placeholderColor = .lightGray
        tfZone.borderActiveColor = k_baseColor
        tfZone.borderInactiveColor = .lightGray
        tfZone.placeholderFontScale = 1.0
        tfZone.delegate = self
        
        addRightPaddingTo(textField: tfZone, imageName: "dropDown")
        
        setupConstraints()
       
        tblView.delegate = self
        tblView.dataSource = self
        
        if strUser_Name != ""
        {
            tfName.text = strUser_Name
        }
        
        if arrPicker.count > 0
        {
            if zone_id != ""
            {
                for d in arrPicker
                {
                    if let strId:String = d["zone_id"] as? String{
                        if zone_id == strId
                        {
                            dictPickerSelected = d
                            if let strTitle:String = self.dictPickerSelected["zone_name"] as? String{
                                self.tfZone.text =  strTitle
                            }
                            break
                        }
                    }
                }
            }
            else
            {
                dictPickerSelected = arrPicker.first!
                if let strTitle:String = self.dictPickerSelected["zone_name"] as? String{
                    self.tfZone.text =  strTitle
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

    @IBAction func btnBuscarClick(btn:UIButton){
        if tfName.text?.isEmpty == true
        {
            self.showAlertWithTitle(title: "Alerta", message: "Por favor ingrese el campo vacío", okButton: "Ok", cancelButton: "", okSelectorName: nil)
        }
        else
        {
            callSearchApiWith(company_id: tfName.text!)
        }
    }
    
    @IBAction func btnTodosClick(btn:UIButton){
        callSearchApiWith(company_id: "")
    }
}

extension AssignVC: UITextFieldDelegate
{
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tfZone
        {
            // it's a picker
            showPickerView()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AssignVC: UIPickerViewDelegate, UIPickerViewDataSource
{
    func showPickerView()
    {
        // UIPickerView
        self.picker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.backgroundColor = UIColor.white
        tfZone.inputView = self.picker
        
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
        tfZone.inputAccessoryView = toolBar
    }
    
    @objc func donePickerClick() {
        picker.removeFromSuperview()
        tfZone.resignFirstResponder()
    }
    
    @objc func cancelPickerClick() {
        picker.removeFromSuperview()
        tfZone.resignFirstResponder()
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
        
        if let strValue:String = dict["zone_name"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
        if let strTitle:String = self.dictPickerSelected["zone_name"] as? String{
            self.tfZone.text =  strTitle
        }
    }
}

extension AssignVC: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict:[String:Any] = arrData[indexPath.row]
        let cell:CellAssignList = tblView.dequeueReusableCell(withIdentifier: "CellAssignList", for: indexPath) as! CellAssignList
        cell.selectionStyle = .none
        cell.lblTitle.text = ""
        cell.lblCount.text = ""
        cell.imgV_User.image = nil
        cell.imgV_User.layer.cornerRadius = 20.0
        cell.imgV_User.layer.borderWidth = 1.2
        cell.imgV_User.layer.borderColor = k_baseColor.cgColor
        cell.imgV_User.layer.masksToBounds = true
        
        cell.imgV_Loc.setImageColor(color: UIColor(named: "AppDarkBackground")!)
        
        if let str:String = dict["company_id"] as? String{
            cell.lblTitle.text = str
        }
        if let str:String = dict["zones_count_str"] as? String{
            cell.lblCount.text = str
        }
        if let str:String = dict["low_res_picture_url"] as? String
        {
            cell.imgV_User.setImageUsingUrl(str)
        }
        
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(self.addClick(btn:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {}
    
    @objc func addClick(btn:UIButton)
    {
        let dict:[String:Any] = arrData[btn.tag]
        
        if let strId:String = self.dictPickerSelected["zone_id"] as? String{
            if let uuid:String = dict["uuid"] as? String
            {
                callAssignZone(zone_id: strId, uuid: uuid)
            }
        }
    }
}

extension AssignVC
{    
    func callSearchApiWith(company_id:String){
        
        var plan_id = ""
        if let id:String = k_userDef.value(forKey: userDefaultKeys.plan.rawValue) as? String
        {
            plan_id = id
        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["plan_id":plan_id, "company_id":company_id]
        
        WebService.requestService(url: ServiceName.GET_UserManageSearch, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let arr:[[String:Any]] = json["response_object"] as? [[String:Any]]
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
    
    
    func callAssignZone(zone_id:String, uuid:String){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":uuid, "zone_id":zone_id]
        
        WebService.requestService(url: ServiceName.POST_AssignZoneUser, method: .post, parameters: param, headers: [:], encoding: "JSON", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let d:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            print("Zone Assigned _ - - - _ - ", d)
                            DispatchQueue.main.async {
                                if let msg:String = json["message"] as? String
                                {
                                    self.showAlertWithTitle(title: "Radar", message: msg, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
