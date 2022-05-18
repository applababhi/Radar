//
//  PerformanceVC.swift
//  Radar
//
//  Created by Shalini Sharma on 5/9/20.
//  Copyright © 2020 Abhishek Bhardwaj. All rights reserved.
//

import UIKit
import TextFieldEffects

class PerformanceVC: UIViewController {

    @IBOutlet weak var tfPeriod: HoshiTextField!
    @IBOutlet weak var collView:UICollectionView!
    
    var arrPicker:[[String:Any]] = []
    var picker : UIPickerView!
    var dictPickerSelected:[String:Any] = [:]

    var arrCollView:[[String:Any]] = []
    
    var userUUIDselected = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfPeriod.isUserInteractionEnabled = false
        
        addRightPaddingTo(textField: tfPeriod, imageName: "dropDown")
        
        tfPeriod.placeholder = "Selecciona el periodo que deseas analizar"
        tfPeriod.placeholderColor = .lightGray
        tfPeriod.borderActiveColor = k_baseColor
        tfPeriod.borderInactiveColor = .lightGray
        tfPeriod.placeholderFontScale = 1.0
        tfPeriod.delegate = self
        
        callPeriods()
    }
    
    @IBAction func btnVerClick(btn:UIButton)
    {
        
    }
}

extension PerformanceVC: UITextFieldDelegate
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

extension PerformanceVC: UIPickerViewDelegate, UIPickerViewDataSource
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
        
        if let strValue:String = dict["month_name"] as? String{
            pickerLabel.text = strValue
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dictPickerSelected = arrPicker[row]
        if let strTitle:String = self.dictPickerSelected["month_name"] as? String{
            self.tfPeriod.text =  strTitle
        }
        
        if let strValue:String = self.dictPickerSelected["month_id"] as? String{
            callPerformance(period_id: strValue)
        }
    }
}

extension PerformanceVC: UICollectionViewDataSource, UICollectionViewDelegate
{
    // MARK: - UICollectionView protocols
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCollView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let dict:[String:Any] = arrCollView[indexPath.item]
        
        let cell:CollCellPerformanceDetail = collView.dequeueReusableCell(withReuseIdentifier: "CollCellPerformanceDetail", for: indexPath as IndexPath) as! CollCellPerformanceDetail
                
        cell.lblTitle.text = ""
        cell.lblDescription.text = ""
        cell.imgView.image = nil
        
        if let str:String = dict["title"] as? String
        {
            cell.lblTitle.text = str
        }
        if let str:String = dict["subTitle"] as? String
        {
            cell.lblDescription.text = str
        }
        if let str:String = dict["image"] as? String
        {
            cell.imgView.image = UIImage(named: str)
        }
  //      cell.imgView.setImageColor(color: k_baseColor)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension PerformanceVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = UIScreen.main.bounds.size.width - 40
        return CGSize(width: (collectionViewWidth/2), height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension PerformanceVC
{
    func callPeriods(){
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = [:]
        
        WebService.requestService(url: ServiceName.GET_ZonePeriods, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
            self.hideSpinner()
        //    print(jsonString)
            
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
                            self.arrPicker = arrperiod
                            
                            DispatchQueue.main.async {
                                if arrperiod.count > 0
                                {
                                    self.tfPeriod.isUserInteractionEnabled = true
                                    let dicth:[String:Any] = arrperiod.first!
                                    if let strTitle:String = dicth["month_name"] as? String{
                                        self.tfPeriod.text =  strTitle
                                    }
                                    if let strValue:String = dicth["month_id"] as? String{
                                        self.callPerformance(period_id: strValue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callPerformance(period_id:String){
        
//        var uuid = ""
//        if let id:String = k_userDef.value(forKey: userDefaultKeys.uuid.rawValue) as? String
//        {
//            uuid = id
//        }
        
        self.showSpinnerWith(title: "Cargando...")
        let param: [String:Any] = ["uuid":userUUIDselected, "period_id":period_id]
       // print(param)
        WebService.requestService(url: ServiceName.POST_UserManagePerformance, method: .get, parameters: param, headers: [:], encoding: "URL", viewController: self) { (json:[String:Any], jsonString:String, error:Error?) in
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
                        if let dJson:[String:Any] = json["response_object"] as? [String:Any]
                        {
                            self.arrCollView.removeAll()
                            DispatchQueue.main.async {
                                
                                if let str:String = dJson["zones_count_str"] as? String
                                {
                                    // 1
                                    self.arrCollView.append(["image":"jagah", "title":str, "subTitle":"Areas en las que estuvo asignado"])
                                }
                                
                                if let str:String = dJson["visits_count_str"] as? String
                                {
                                    // 2
                                    self.arrCollView.append(["image":"banda", "title":str, "subTitle":"Visitas Registradas en el Periodo"])
                                }
                                if let str:String = dJson["total_sales_count_str"] as? String
                                {
                                    // 3
                                    self.arrCollView.append(["image":"simcard", "title":str, "subTitle":"SIMs Vendidas en el Periodo"])
                                }
                                if let str:String = dJson["sv_sales_count_str"] as? String
                                {
                                    // 4
                                    self.arrCollView.append(["image":"simcardQuestion", "title":str, "subTitle":"SIMs Vírgenes Vendidas en el Periodo"])
                                }
                                if let str:String = dJson["sr_sales_count_str"] as? String
                                {
                                    // 5
                                    self.arrCollView.append(["image":"simcardDollar", "title":str, "subTitle":"SIMs con Recarga Vendidas en el Periodo"])
                                }
                                if let str:String = dJson["sa_sales_count_str"] as? String
                                {
                                    // 6
                                    self.arrCollView.append(["image":"simcardPhone", "title":str, "subTitle":"SIMs Activos Vendidas en el Periodo"])
                                }
                                if let str:String = dJson["tokens_count_str"] as? String
                                {
                                    // 7
                                    self.arrCollView.append(["image":"moti", "title":str, "subTitle":"Diamantes Obtenidos en el Periodo"])
                                }
                                if let str:String = dJson["rewards_count_str"] as? String
                                {
                                    // 8
                                    self.arrCollView.append(["image":"trophey_", "title":str, "subTitle":"Recompensas Obtenidas en el Periodo"])
                                }
                                
                                if self.collView.delegate == nil
                                {
                                    self.collView.delegate = self
                                    self.collView.dataSource = self
                                }
                                self.collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

